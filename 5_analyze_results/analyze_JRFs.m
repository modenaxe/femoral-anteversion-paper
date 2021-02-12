%                                                                         %
%    Author:   Luca Modenese,  2017                                       %
%    email:    l.modenese@sheffield.ac.uk                                 %
% ----------------------------------------------------------------------- %
clear;clc; fclose all;close all;
% add functions
addpath(genpath('./MatlabFunctions_MSK'));
addpath(genpath('../../opensim-pipelines/Dynamic_pipeline/Matlab_pipeline_functions'))

% %========== SUBJECTS ======================
% root folder for placing the folders for each subject
database_root_folder = [pwd,'/2_Dataset'];

% model names
subj_set = {'GC5_FemAntev-2Deg',...
            'GC5_FemAntev5Deg',...
            'GC5_FemAntev12Deg',...
            'GC5_FemAntev19Deg',...
            'GC5_FemAntev26Deg',...
            'GC5_FemAntev33Deg',...
            'GC5_FemAntev40Deg'};

% folder where to get the Mat summaries
mat_summary_folder =  './Results_Mat_Summaries';

% list of fields to retrieve the JRF from the summaries
JRF_set = {'hip_JRF', 'knee_JRF', 'ankle_JRF'};

%---------------------------------------------------------------------------

% looping through the JRF
for joint = 1:length(JRF_set)
    
    ref_ind = 0;
    
    % current JR to plot
    cur_jr_name = JRF_set{joint};

    % looping through the methods for estimation of Fiso
    for n_antev = 1:length(subj_set)
        
        % current model
        cur_model = subj_set{n_antev};
        
        % specify database (fix not working names)
        summary_file = [mat_summary_folder,'\','Summary_', strrep(cur_model,'-','_'),'.mat'];
        load(summary_file)
        
        % get JRF set
        JRF = SummaryBiomech.JRF;
        
        % get current jrf for current howWasComputedLoptLts
        var = getValueColumnForHeader(JRF, cur_jr_name);
        JR_gait_trials = squeeze(var);

        if strcmp(cur_model, 'GC5_FemAntev12Deg') == 1
            ref_ind = n_antev;
        end

        % metrics
        all_sims_JRFs(:,:, n_antev,joint) = JR_gait_trials;
        first_peaks_sims(n_antev, : , joint ) = max(JR_gait_trials(1:35, :));
        second_peaks_sims(n_antev, : , joint ) = max(JR_gait_trials(35:end, :));
        
        clear SummaryBiomech var summary_file
    end
end


%% compare against in vivo measurements at the knee joint

% load eTibia data
load('eTibia_data.mat')
BW = 75*9.81;

% EXP DATA: eTibia total force [frames x trials] 
eTibia_trials_totForce = squeeze(eTibia_data.GC5.ngait_og.data(:,3,:))/BW;

% SIM DATA: extract KJC and reorder them as in eTibia [frames x trials x femAntev]
% trials (second dimension) are adjusted to be in the same order as eTibia
% no_gait 1 (order: 11 - 1 - 3 - 8 -9)
sims_KneeForce = squeeze(all_sims_JRFs(:,[2,1,3:end], : ,2));

% absolute error for each frame
abs_err = sims_KneeForce-eTibia_trials_totForce;

% RMSE for each trial
RMSE = squeeze(sqrt(mean(abs_err.^2, 1)));
mean_RMSE = mean(RMSE)';
std_RMSE = std(RMSE)';

% % correlation coefficient
for n_antev = 1:length(subj_set)
cur_sims = sims_KneeForce(:,:,n_antev);
    for n_trial = 1:size(cur_sims, 2)
        [R(:,:,n_trial, n_antev), P(:,:,n_trial,n_antev)]= corrcoef(cur_sims(:,n_trial), eTibia_trials_totForce(:,n_trial));
    end
    R1(:,n_antev) = squeeze(R(1,2,:,n_antev));
    P1(:,n_antev) = squeeze(P(1,2,:,n_antev));
end
mean_corr_coeff = mean(R1)';
std_corr_coeff = std(R1)';
mean_p_val = mean(P1)';

% Note that first peak is larger in all trials of eTibia
first_peaks_etibia = max(eTibia_trials_totForce(1:35,:));
second_peaks_etibia = max(eTibia_trials_totForce(35:end,:));

first_knee_peaks_sims = squeeze(max(sims_KneeForce(1:35,:,:)))';
second_knee_peaks_sims = squeeze(max(sims_KneeForce(35:end,:,:)))';

% verif
% first_peaks_sims2-first_peaks_sims(:,[2,1,3:end],2);

% absolute error between peaks
abs_error_peak1 = 100*(first_knee_peaks_sims-first_peaks_etibia)./first_peaks_etibia;
abs_error_peak2 = 100*(second_knee_peaks_sims-second_peaks_etibia)./second_peaks_etibia;

% mean and std (peak 1)
mean_error_peak1 = mean(abs_error_peak1,2);
std_error_peak1 = std(abs_error_peak1,0,2);
% mean and std (peak 2)
mean_error_peak2 = mean(abs_error_peak2,2);
std_error_peak2 = std(abs_error_peak2,0,2);

% how much are the peaks varying?
% percent_var = (second_peaks_sims-second_peaks_sims(ref_ind,:,:))./second_peaks_sims(ref_ind,:,:)*100;
percent_var = (first_peaks_sims-first_peaks_sims(ref_ind,:,:))./first_peaks_sims(ref_ind,:,:)*100;

% check the % variations on single joints
hip_var  = percent_var(:,:,1);
knee_var = percent_var(:,:,2);
ankle_var = percent_var(:,:,3);

% mean and std
mean_hip_var = mean(hip_var, 2);  std_hip_var = std(hip_var, 0, 2);
mean_knee_var = mean(knee_var, 2);  std_knee_var = std(knee_var, 0, 2);
mean_ankle_var = mean(ankle_var, 2);  std_ankle_var = std(ankle_var, 0, 2);

% table of results
col_var = {'FemAntev-2'; 'FemAntev+5'; 'FemAntev+12 (nominal)'; 'FemAntev+19'; 'FemAntev+26'; 'FemAntev+33'; 'FemAntev+40'};
variation_table = table(col_var, mean_hip_var, std_hip_var, mean_knee_var, std_knee_var, mean_ankle_var, std_ankle_var,...
                        mean_error_peak1,  std_error_peak1, mean_error_peak2, std_error_peak2, mean_RMSE, std_RMSE, mean_corr_coeff, std_corr_coeff, ...
                   'VariableNames',{'Femoral Anteversion Angle', 'Mean var (HIP) [%]', 'STD hip','Mean var (KNEE) [%]', 'STD knee', 'Mean var (ANKLE) [%]', 'STD ankle',...
                   'Mean Error Peak1 [BW]', 'STD Error Peak1 [BW]', 'Mean Error Peak2 [BW]','STD Error Peak2 [BW]','Mean RMSE [BW]', 'STD RMSE [BW]','Mean corr coeff', 'STD corr coeff'});

disp(variation_table)

writetable(variation_table, 'table_results.xls')