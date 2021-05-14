%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This script computes how much the musculotendon lengths are changing in
% the default pose of the OpenSim models that have been created with the
% bone deformation tool.
% ----------------------------------------------------------------------- %
clear;clc

% import libraries
import org.opensim.modeling.*

% %========== SUBJECTS ======================
% root folder for placing the folders for each subject
model_root_folder = '../3_deform_femur_l';

% model names
subj_set = {'GC5_FemAntev-2Deg',...
            'GC5_FemAntev5Deg',...
            'GC5_FemAntev12Deg',...
            'GC5_FemAntev19Deg',...
            'GC5_FemAntev26Deg',...
            'GC5_FemAntev33Deg',...
            'GC5_FemAntev40Deg'};

for n_model = 1:length(subj_set)
    
    nmv = 1;
    
    % model file path
    model_file = fullfile(model_root_folder, [subj_set{n_model},'.osim']);
    
    % read in the model
    curr_model = Model(model_file);
    
    % initialise the model
    s = curr_model.initSystem();
    
    % get the muscles
    muscle_set = curr_model.getMuscles();
    
    for nm = 0:muscle_set.getSize()-1

        % compute the lengths
        curr_muscle = muscle_set.get(nm);
        
        % muscle name
        curr_muscle_name = char(curr_muscle.getName());
        
        % skip right muscles and save names
        if strcmp(curr_muscle_name(end-1:end), '_r')
            continue
        else
            if n_model == 1
                muscle_name_vec(nmv) = {curr_muscle_name};
            end
            % compute the lengths
            curr_length(n_model, nmv) = curr_muscle.getLength(s);
            nmv = nmv+1;
        end        
    end
    
    % compute the moment arms wrt hip and knee
    % (state, coordinate)
    % curr_muscle.computeMomentArm(s, coord)
    

end

% differences from nominal model (all muscles)
delta_L = curr_length - curr_length(3,:);

% ASSUMPTION: if the comulative change in length across the models is less
% than 1 mm then it is considered negligible.
% These are muscles with attachment on the femur!
muscles_of_interest_ind = sum(abs(delta_L))>0.001;
muscles_of_interest_names = muscle_name_vec(muscles_of_interest_ind);
muscles_of_interest_delta_L = delta_L(:, muscles_of_interest_ind);

% compute % variations
perc_vars = 100 * muscles_of_interest_delta_L ./ curr_length(3,muscles_of_interest_ind);
% subset of interest
var_threshold = 2;
ind_var = max(abs(perc_vars))>var_threshold;

% result structure
mus_len_struct.colheaders = muscles_of_interest_names(ind_var);
mus_len_struct.data = perc_vars(:,ind_var);
writeStorageFile(mus_len_struct, 'muscle_perc_variations.sto', 'Percentage variation of muscle lengths')
