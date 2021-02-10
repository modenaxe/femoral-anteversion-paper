%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This script makes weaker, by a specified strength ratio, the muscles
% crossing the walker_knee joint in the Rajagopal model.
% The script can be easily changed to weaken the muscles crossing other
% joints.
% ----------------------------------------------------------------------- %

clear; clc

% import opensim libraries
import org.opensim.modeling.*

% how weaker the knee-spanning muscles will be
strength_ratio = 0.6;

% joint of interest
joint_of_interest = 'walker_knee_l';

% read in the scaled Rajagopal model
osimModel = Model('Rajagopal2015-scaled.osim');

% get the Muscles
muscles = osimModel.getMuscles();

% loop through the muscles
for nm = 0:muscles.getSize()-1
    
    % current muscle
    cur_mus = muscles.get(nm);
    cur_mus_name = char(cur_mus.getName());
    
    % get the joints spanned by the current muscle
    jointNameSet = getJointsSpannedByMuscle(osimModel, cur_mus_name);
    
    % loop through the spanned joints
    for nj = 1:length(jointNameSet)
        
        % current joint
        cur_joint = jointNameSet{nj};
        
        % if the current joint is the "walker_knee_l", then make the muscle
        % weaker
        if strcmp(cur_joint, joint_of_interest)
           
            disp([cur_mus_name, ' crosses the knee_l. Reducing max isometric force by ',num2str((1-strength_ratio)*100),'%.']);
           
           % assign a new max isometric force
           cur_mus.setMaxIsometricForce(cur_mus.getMaxIsometricForce * strength_ratio);
        end
    end
end

% save the weaker model and change its name
osimModel.setName([char(osimModel.getName), '_x',num2str(strength_ratio),'_kneeFiso']);

% print weaker model
osimModel.print('GC5.osim');

