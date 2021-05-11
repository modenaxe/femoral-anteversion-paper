% import libraries
import org.opensim.modeling.*

osimAtlasModel = Model('./ScaledMuscleParams_sims/ATLAS_GC5_FemAntev12Deg.osim');

osimTargetModel = Model('./ScaledMuscleParams_sims/GC5_femAntev40Deg/GC5_femAntev40Deg.osim');

osimScaledModel = scaleMusParams(osimAtlasModel, osimTargetModel);

osimScaledModel.print('./ScaledMuscleParams_sims/GC5_femAntev40Deg_scaled/GC5_femAntev40Deg_scaled.osim');