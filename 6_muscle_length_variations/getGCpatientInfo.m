%-------------------------------------------------------------------------%
% Copyright (c) 2021 Modenese L.                                          %
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
%    Author:   Luca Modenese                                              %
%    email:    l.modenese@imperial.ac.uk                                  %
%-------------------------------------------------------------------------%
%
% Quick script to visualize contact forces for visual check.
% Note that they are not cropped in trials (yet).
%-------------------------------------------------------------------------%

function Info = getGCpatientInfo(GC_nr)

    switch GC_nr
        case 'GC1'
            Info.id         = 'JW';
            Info.H          = 1.66; %m
            Info.M          = 64.6; %kg
            Info.kneeSide   = 'Right'; % instrumented knee side
            Info.shoes      = 'New Balance SL-1 Fit walking shoes';
            Info.prosthesis = 'eKnee';
            Info.gender     = 'male';
            Info.hip_implant= 'yes';
        case 'GC2'
            Info.id         = 'DM';
            Info.H          = 1.72; %m
            Info.M          = 67.0; %kg
            Info.kneeSide   = 'Right'; % instrumented knee side
            Info.shoes      = 'New Balance 609 sneakers';
            Info.prosthesis = 'eTibia';
            Info.gender     = 'male';
            Info.hip_implant= 'no';
        case 'GC3'
            Info.id         = 'SC';
            Info.H          = 1.67; %m
            Info.M          = 78.4; %kg
            Info.kneeSide   = 'Left'; % instrumented knee side
            Info.shoes      = 'Keds women''s sneakers size 10';
            Info.prosthesis = 'eTibia';
            Info.gender     = 'female';
            Info.hip_implant= 'no';
        case 'GC4'
            Info.id         = 'JW';
            Info.H          = 1.68; %m
            Info.M          = 66.7; %kg
            Info.kneeSide   = 'Right'; % instrumented knee side
            Info.shoes      = 'Rockport flat bottom sneakers';
            Info.prosthesis = 'eTibia';
            Info.gender     = 'male';
            Info.hip_implant= 'yes';
        case 'GC5'
            Info.id         = 'PS';
            Info.H          = 1.8; %m
            Info.M          = 75; %kg
            Info.kneeSide   = 'Left'; % instrumented knee side
            Info.shoes      = 'Asics Men''s GT-2140 Running Shoes';
            Info.prosthesis = 'eTibia';
            Info.gender     = 'male';
            Info.hip_implant= 'no';
        case 'GC6'
            Info.id         = 'DM';
            Info.H          = 1.72; %m
            Info.M          = 70; %kg
            Info.kneeSide   = 'Right'; % instrumented knee side
            Info.shoes      = 'New Balance Men''s 927 Sneakers, Size 9.5D';
            Info.prosthesis = 'eTibia';
            Info.gender     = 'male';
            Info.hip_implant= 'no';
        otherwise
            error('Please select a Grand Challenge in the format ''GC#''')
    end
end