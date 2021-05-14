%-------------------------------------------------------------------------%
%    Copyright (c) 2021 Modenese L.                                       %
%    Author:   Luca Modenese,  2021                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This script takes the OpenSim model with the largest changes in
% musculotendon lengths and scale the optimal fiber length and tendon slack
% length in the same way OpenSim does when scaling a model: both
% architectural parameters are scaled so that their ratio to the total
% musculotendon length stay constant.
% ----------------------------------------------------------------------- %

import org.opensim.modeling.*

osimAtlasModel = Model('./ScaledMuscleParams_sims/ATLAS_GC5_FemAntev12Deg.osim');

osimTargetModel = Model('./ScaledMuscleParams_sims/GC5_femAntev40Deg/GC5_femAntev40Deg.osim');

osimScaledModel = scaleMusParams(osimAtlasModel, osimTargetModel);

osimScaledModel.print('./ScaledMuscleParams_sims/GC5_femAntev40Deg_scaled/GC5_femAntev40Deg_scaled.osim');