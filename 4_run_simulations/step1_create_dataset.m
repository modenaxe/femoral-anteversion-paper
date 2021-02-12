%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese                                              %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% script to quickly create a dataset structure to use for running a
% standard opensim workflow
% ----------------------------------------------------------------------- %
clear;clc; fclose all;close all;

% settings
take_model_from_folder = '../3_deform_femur_l';
template_IK_Tasks_file = 'database_IK_Tasks.xml';
c3d_folder = 'c3d';
copy_to_folder = './Dataset';

model_list = dir([take_model_from_folder,filesep,'*.osim']);
for n_p = 1:length(model_list)
    
    cur_model = model_list(n_p).name;
    model_name = cur_model(1:end-5);

    disp(['Creating simulation folder for ', model_name]);
    take_file    = fullfile(take_model_from_folder, cur_model);
    mkdir(fullfile(copy_to_folder, model_name))
    
    
    copy_to_file = fullfile(copy_to_folder,model_name, cur_model);
    copyfile(take_file, copy_to_file,'f');
    disp('* model copied');
    
    % copy correct IK Task
    copy_IK_Tasks_file = fullfile(copy_to_folder,model_name,[model_name,'_IK_Tasks.xml']);
    copyfile(template_IK_Tasks_file, copy_IK_Tasks_file,'f');
    disp('* IK tasks copied');
    
    % copy c3d folder
    copy_c3d_folder = fullfile(copy_to_folder,model_name,c3d_folder);
    copyfile(c3d_folder, copy_c3d_folder);
    disp('* raw c3d copied');
    
    disp('------------------------------------------')
    
end
