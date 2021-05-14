%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese                                              %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
%
clear; clc; 
fclose all;

addpath(genpath('../../opensim-pipelines/Dynamic_pipeline/Matlab_pipeline_functions'))

% ------------ SETTINGS ---------------------
% root folder of dataset
database_root_folder = [pwd,'/ScaledMuscleParams_sims'];

% model names
model_set = {'GC5_FemAntev40Deg_scaled'};

activity_set ={'_ngait_og'};

% specify the analyses to be performed
analysis_set ={'IK','SO','JRF'};
%----------------------------------------------


for n_subj = 1:length(model_set)
    
    % get current subject and available time points
    curr_subj = model_set{n_subj};
    
    % get patient infos
    Info = getGCpatientInfo(curr_subj(1:3));
    BW = Info.M * 9.8180;
    id = Info.id;
            
            % creates folder structure
            folders = createFolderStructurePipeline(curr_subj,database_root_folder);
            
            for n_act = 1:length(activity_set)
                
                % select activity
                curr_activity = [id, activity_set{n_act}];
                
                % get the list of trials for that activity
                c3d_file_list = getC3DTrialsListForActivity(curr_subj,curr_activity, folders);
                
                % nr of trials for that activity
                n_trials_set = 1:length(c3d_file_list);
                
                for n_trial = n_trials_set
                    
                    % root name of the simulation
                    curr_c3d_trial_name = c3d_file_list(n_trial).name;
                    display(['Processing: ', curr_c3d_trial_name])
                    % file index for the current simulation
                    fileIndex = createFileIndexPipeline(curr_subj, curr_c3d_trial_name, folders);
                    
                    %creating a log file
                    aLogFile            = fullfile(fileIndex.extraction_data_log_file);
                    fid                 = fopen(aLogFile,'w+');
                    fclose(fid);
                    
                    % start recording the output in the message window
                    diary(aLogFile)
                    
                    % reading acquisition using BTK
                    acq =btkReadAcquisition(fileIndex.c3d_file);
                    
                    % all the outputs can go in sim_struct
                    [sim_struct, fileIndex] = setupSimulation(acq, fileIndex);
                    
                    % EMG first, the other data processing crops the acquisition
%                     EMGstruct = prepareEMG(acq, folders.EMG_folder, sim_struct, EMG_channels_list);
                    
                    % 1) prepare marker data (trc file)
                    prepareMarkerData(acq, sim_struct, fileIndex);
                    
                    % 2) prepare GRF mot file
                    % NB: sim_Struct HAS TO BE AN OUTPUT or the GRFs are
                    % not stored in the resulting mat summaries
                    sim_struct = extractGRFdata(acq, sim_struct, fileIndex);
                    
                    % 3) generate external forces xml file
                    % to do: maybe join in a single function
                    check_extLoads_consistency(acq, sim_struct);
                    generateXmlExternalLoads(sim_struct, fileIndex)
                    
                    % clean memory
                    btkDeleteAcquisition(acq)
                    diary off
                    
                    % 5) run analyses
                    for n_analysis = 1:length(analysis_set)
                        % analysis to be performed
                        curr_analysis = analysis_set{n_analysis};
                        % execute the analys
                        runAnalysis_autopipeline(curr_analysis, sim_struct, folders, fileIndex);
                    end
                    
                    % 6) write matlab output
                    generateMatSummaryOutput_v3(sim_struct, fileIndex)
                    clear EMGstruct sim_struct
                end
            end
            

%             % ========= EMG ==================
%             % normalize EMG: this can only be done after processing all EMGs
%             normalizeEMG(folders.EMG_folder)
%             % adding normalized EMG to mat summary
%             addEMG2MatSummary(folders.Mat_summary_folder, folders.EMG_folder)
%             %=======================================

            
            % Commented for no reason but processing
            % % processing results: resampling on 101 points
            N_resampling = 100;
            if ~strcmp(curr_activity,'Static')
                subj_OS_summary = createSubjMatSummary(curr_subj, folders.Mat_summary_folder, N_resampling,'OS');
            end
            
            % tide up the folders: delete those that were not filled
            rm_list = {'Biomarkers','BodyKin','MFD','MomArms','MTL','plots','ProbeReport','scaling'};
            for n_rm = 1:length(rm_list)
                if isfolder(fullfile(folders.subj_folder,rm_list{n_rm}))
                    rmdir(fullfile(folders.subj_folder,rm_list{n_rm}))
                end
            end
            
%         end
end

cd(database_root_folder)
% rmpath(genpath('../Matlab_pipeline_functions'))

