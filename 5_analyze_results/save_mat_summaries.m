%-------------------------------------------------------------------------%
% Copyright (c) 2020 Modenese L.                                          %
%                                                                         %
% Licensed under the Apache License, Version 2.0 (the "License");         %
% you may not use this file except in compliance with the License.        %
% You may obtain a copy of the License at                                 %
% http://www.apache.org/licenses/LICENSE-2.0.                             %
%                                                                         %
% Unless required by applicable law or agreed to in writing, software     %
% distributed under the License is distributed on an "AS IS" BASIS,       %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         %
% implied. See the License for the specific language governing            %
% permissions and limitations under the License.                          %
%                                                                         %
%    Author:   Luca Modenese,  2020                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% utility function to convert the simulation results in just two summary
% files to use with higher level functions to plot results and perform
% statistical analyses.
% ----------------------------------------------------------------------- %
function save_mat_summaries()
clear;clc;
fclose all;close all;
addpath(genpath('../../opensim-pipelines/Dynamic_pipeline/Matlab_pipeline_functions'))
%---------------------------------------------------------------------------
% where the simulations are
database_root_folder = '../4_run_simulations/Dataset';

% name of the models used in the simulations
model_set = {'GC5_FemAntev-16Deg',...
            'GC5_FemAntev-9Deg',...
            'GC5_FemAntev-2Deg',...
            'GC5_FemAntev5Deg',...
            'GC5_FemAntev12Deg',...
            'GC5_FemAntev19Deg',...
            'GC5_FemAntev26Deg',...
            'GC5_FemAntev33Deg',...
            'GC5_FemAntev40Deg'};

% where to store the summary
mat_summary_folder = './Results_Mat_Summaries';

% mass of the subject represented by the automatic and manual model
bodyMass = 75; %kg
BW = bodyMass*9.81;
%---------------------------------------------------------------------------

% create summary folder
if ~isfolder(mat_summary_folder); mkdir(mat_summary_folder); end

% getting data from simulations of each model
for n_subj = 1:length(model_set)
    
% initializations of all storage variables
pelvis_tilt= []; pelvis_list = []; pelvis_rotation = [];
hip_flexion = []; hip_flexion_moment = [];hip_adduction = []; hip_adduction_moment = [];
hip_rotation = []; hip_rotation_moment = []; knee_angle = []; knee_angle_moment = [];
ankle_angle = []; ankle_angle_moment = []; subtalar_angle = []; subtalar_angle_moment = [];
KINEMATICS = []; KINETICS = []; ToeOffV_R = []; hip_JRF = []; knee_JRF = []; ankle_JRF = [];


    
    % extract details for the current model
    cur_model_name = model_set{n_subj};
    display(['Processing: ', cur_model_name])
    
    % summary folders in model folder structure
    Mat_summary_folder = fullfile(database_root_folder,cur_model_name,'Mat_summary');
    % summary file
    cur_model_name = strrep(cur_model_name, '-','_');
    summary_file = fullfile(Mat_summary_folder, [cur_model_name,'_OS_allTrials.mat'] );
    % load and remove external structure layer
    subj_OS_summary = load(summary_file);
    eval(['subj_OS_summary = subj_OS_summary.',cur_model_name,'_OS_summary;'])

    if ~isempty(subj_OS_summary) 
        
        % PULLING TOE OFF
        ToeOffV_R = [ToeOffV_R, subj_OS_summary.toe_off_vec]; %#ok<AGROW>
        
        % STORING ALL KINEMATICS TOGETHER (with correct signs for plotting)
        pelvis_tilt    = -squeeze(getValueColumnForHeader(subj_OS_summary,  'pelvis_tilt'));
        pelvis_list    = -squeeze(getValueColumnForHeader(subj_OS_summary,  'pelvis_list'));
        pelvis_rotation= squeeze(getValueColumnForHeader(subj_OS_summary,  'pelvis_rotation'));
        hip_flexion    = squeeze(getValueColumnForHeader(subj_OS_summary,  'hip_flexion_r'));
        hip_adduction  = squeeze(getValueColumnForHeader(subj_OS_summary,  'hip_adduction_r'));
        hip_rotation   = squeeze(getValueColumnForHeader(subj_OS_summary,  'hip_rotation_r'));
        knee_angle     =-(squeeze(getValueColumnForHeader(subj_OS_summary, 'knee_angle_r')));
        ankle_angle    = squeeze(getValueColumnForHeader(subj_OS_summary,  'ankle_angle_r'));
        subtalar_angle = squeeze(getValueColumnForHeader(subj_OS_summary,  'subtalar_angle_r'));
        
        % STORING ALL DYNAMICS TOGETHER (with correct signs for plotting)
        hip_flexion_moment   = -squeeze(getValueColumnForHeader(subj_OS_summary, 'hip_flexion_r_moment'))/bodyMass;
        hip_adduction_moment = -squeeze(getValueColumnForHeader(subj_OS_summary, 'hip_adduction_r_moment'))/bodyMass;
        hip_rotation_moment  = squeeze(getValueColumnForHeader(subj_OS_summary, 'hip_rotation_r_moment'))/bodyMass;
        knee_angle_moment    = squeeze(getValueColumnForHeader(subj_OS_summary, 'knee_angle_r_moment'))/bodyMass;
        ankle_angle_moment   = -squeeze(getValueColumnForHeader(subj_OS_summary, 'ankle_angle_r_moment'))/bodyMass;
        subtalar_angle_moment= -squeeze(getValueColumnForHeader(subj_OS_summary, 'subtalar_angle_r_moment'))/bodyMass;
        
        
        % list of JRF to pull
        side = 'l';
        jrf_list_l{1}= ['hip_',side,'_on_femur_',side,'_in_femur_',side];
        jrf_list_l{2}= ['walker_knee_',side,'_on_tibia_',side,'_in_tibia_',side];
        jrf_list_l{3}= ['ankle_',side,'_on_talus_',side,'_in_talus_',side];
        
        for njrf = 1:length(jrf_list_l)
            curr_jrf_label_l = jrf_list_l{njrf};
            % calculate norms
            subj_OS_summary = operateOnMatResStruct(subj_OS_summary,'norm',{[curr_jrf_label_l,'_fx']; [curr_jrf_label_l,'_fy']; [curr_jrf_label_l,'_fz']}, curr_jrf_label_l); hold on;
            
            close all
            % normalize to body weight
            subj_OS_summary = operateOnMatResStruct(subj_OS_summary, 'scale', {curr_jrf_label_l, 1/BW}, curr_jrf_label_l);
            if njrf == 1
                hip_JRF  = [hip_JRF, squeeze(getValueColumnForHeader(subj_OS_summary, curr_jrf_label_l))];
            end
            if njrf == 2
                knee_JRF = [knee_JRF, squeeze(getValueColumnForHeader(subj_OS_summary, curr_jrf_label_l))];
            end
            if njrf == 3
                ankle_JRF = [ankle_JRF, squeeze(getValueColumnForHeader(subj_OS_summary, curr_jrf_label_l))];
            end
        end
        
    end

%------------- create summary structures ------------------
% store kinematics
KINEMATICS.colheaders = {'pelvis_tilt', 'pelvis_list','pelvis_rotation',...
                         'hip_flexion','hip_adduction','hip_rotation',...
                         'knee_angle','ankle_angle','subtalar_angle'};
KINEMATICS.data = reshape([pelvis_tilt; pelvis_list; pelvis_rotation;...
                           hip_flexion;  hip_adduction;  hip_rotation;...
                           knee_angle; ankle_angle;subtalar_angle],...
                           101,length(KINEMATICS.colheaders),[]);

% store kinetics
KINETICS.colheaders   = {'hip_flexion_moment','hip_adduction_moment',...
                         'hip_rotation_moment','knee_angle_moment',...
                         'ankle_angle_moment', 'subtalar_angle_moment'};
KINETICS.data = reshape([hip_flexion_moment; hip_adduction_moment;...
                         hip_rotation_moment; knee_angle_moment;...
                         ankle_angle_moment;subtalar_angle_moment],...
                         101,length(KINETICS.colheaders),[]);
% store JRFs
JRF.colheaders          = { 'hip_JRF','knee_JRF', 'ankle_JRF'};
JRF.data = reshape([hip_JRF; knee_JRF; ankle_JRF], 101, 3, []);

% hyper-structure
SummaryBiomech.KINEMATICS = KINEMATICS;
SummaryBiomech.KINETICS = KINETICS;
SummaryBiomech.JRF = JRF;
SummaryBiomech.ToeOffV_R = ToeOffV_R;


% save the summary for this model
save([mat_summary_folder, filesep, ['Summary_',cur_model_name,'.mat']], 'SummaryBiomech')
disp(['Summary files written in folder: ',mat_summary_folder])

clear subj_OS_summary
end
end

%-------------------------------------------------------------------------%
% Copyright (c) 2020 Modenese L.                                          %
%                                                                         %
% Licensed under the Apache License, Version 2.0 (the "License");         %
% you may not use this file except in compliance with the License.        %
% You may obtain a copy of the License at                                 %
% http://www.apache.org/licenses/LICENSE-2.0.                             %
%                                                                         %
% Unless required by applicable law or agreed to in writing, software     %
% distributed under the License is distributed on an "AS IS" BASIS,       %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         %
% implied. See the License for the specific language governing            %
% permissions and limitations under the License.                          %
%                                                                         %
%    Author:   Luca Modenese,  2020                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% Function that allows to retrieve the value of a specified variable whose
% name is specified in var_name
%
% INPUTS
% struct:   is a structure with fields 'colheaders', the headers, and 'data'
%           that is a matrix of data.
% var_name: the name of the variable to extract
%
% OUTPUTS
% var_value: the column of the matrix correspondent to the header specified
%               in input.
%
% modified 29/6/2016
% made changes to ensure that only one variable will be extracted.
% it also ensure extraction of 3D data by taking the 3rd dimension.
% includes modifications implemented in getValueColumnForHeader3D.m
% ----------------------------------------------------------------------- %
function var_value = getValueColumnForHeader(struct, var_name)%, varargin)

% bug scoperto da Giuliano 11/07/2017
if (iscell(var_name)) && isequal(length(var_name),1)
    var_name = var_name{1};
elseif (iscell(var_name)) && length(var_name)>1
    error('getValueColumnForHeader.m Input var_name is a cell array with more than one element. Not supported at the moment. Please give a single label.')
end

% initializing allows better control outside the function
var_value = [];

% gets the index of the desired variable name in the colheaders of the
% structure from where it will be extracted
var_index = strcmp(struct.colheaders, var_name);%june 2016: strcmp instead of strncmp ensures unique correspondance

if sum(var_index) == 0
    % changed from error to warning so the output is the empty set
    warning(['getValueColumnForHeader.m','. No header in structure is matching the name ''',var_name,'''.'])
else
    % check that there is only one column with that label
    if sum(var_index) >1
        display(['getValueColumnForHeader.m',' WARNING: Multiple columns have been identified in summary with label ', var_name]);
        pause
    end
    
    % my choice was to automatically extract the third dimension of a set
    % using the 2D column headers indices
    if ndims(struct.data)==3
        var_value = struct.data(:,var_index,:);
    else
        var_value = struct.data(:,var_index);
    end
    
    % HERE IS AN ALTERNATIVE USING VARARGIN
%     % maybe this could be better handled 
%     if isempty(varargin)
%         var_value = struct.data(:,var_index);
%     elseif strcmp(varargin{1},'3D')==1
%         display('Extracting 3D data.')
%         % uses the index to retrieve the column of values for that variable.
%         var_value = struct.data(:,var_index,:);
%     end
end

end
