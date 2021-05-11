%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% scaling the muscle properties using an anthropometric method consisting 
% of maintaining the proportion of tendon
% and optimal fiber length with respect to the total length of the
% muscle-tendon unit.

function osimScaledModel = scaleMusParams(osimAtlasModel, osimTargetModel)

% import libraries
import org.opensim.modeling.*

% import muscles
osimModel_atlas = osimAtlasModel;
osimModel_pers = osimTargetModel;

% extracting muscles from personalized model: scaled or subject specific.
muscleSet_pers = osimModel_pers.getMuscles;
N_mus = muscleSet_pers.getSize;

s_atlas = osimModel_atlas.initSystem;
s_pers = osimModel_pers.initSystem;

disp('=========================================================')
for n_m = 0:N_mus-1
    
    % extract muscle
    curr_mus        = muscleSet_pers.get(n_m);
    curr_mus_name   = curr_mus.getName;
    
    % get length
    Lmt_pers       = curr_mus.getLength(s_pers);
    
    % inform user
   
    disp(['Updating muscle parameters of: ', char(curr_mus_name)]);
    
    % getting correspondent atlas name
    curr_mus_atlas  = osimModel_atlas.getMuscles.get(deblank(char(curr_mus_name)));
    Lmt_atlas       = curr_mus_atlas.getLength(s_atlas);
    Lopt_ratio      = curr_mus_atlas.getOptimalFiberLength/Lmt_atlas;
    Lts_ratio       = curr_mus_atlas.getTendonSlackLength/Lmt_atlas;
    
    % calculating muscle parameters for personalized model.
    Lopt_pers   = Lopt_ratio*Lmt_pers;
    Lts_pers    = Lts_ratio*Lmt_pers;
    
%     % used to test the function with a model scaled in OpenSim: errors in
%     % the order of 10-6
%     err (n_m+1) = ((curr_mus.getOptimalFiberLength-Lopt_pers)/1);
%     plot(err); xlabel('muscles'); ylabel('error')
    
    % assigning them to the personalized model
    curr_mus.setOptimalFiberLength(Lopt_pers);
    curr_mus.setTendonSlackLength(Lts_pers);
    
end

disp('=========================================================')

% giving updated model as output
osimScaledModel = osimModel_pers;

end