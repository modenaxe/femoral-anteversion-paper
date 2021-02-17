# femoral_anteversion_paper
repository for sharing the simulations for a paper investigating the effect of femoral anteversion on the joint reactions of the lower limb

# Available MATLAB scripts
The provided MATLAB scripts produce the results described in the following table:

| Script name | Script action | Related item in the manuscript|
| --- | --- | --- |
| `make_knee_muscle_weaker.m` | reduces the strenght of knee-spanning muscles in the specified model by 40%. Depends on `getJointsSpannedByMuscle.m` | N/A |
| `create_femAnt_models.m` | creates OpenSim model with the specified range of femoral anteversion angles. The baseline model has a femoral anteversion angle of 12 degrees. Depends on the bone-deformation toolbox in the `msk_bone_deformation` folder| N/A |
| `step1_create_dataset.m` | arranges contents of folders for running the simulations (only results are provided). | N/A |
| `save_mat_summaries.m` | converts the simulation results in a format usable for further analyses. | N/A |
| `plot_JRFs.m` | plots the joint reaction forces obtained from simulations with models having different femoral anteversion. | Figure 2. |
| `analyze_JRFs.m` | runs basic analyses on the joint reaction forces resulting from the simulations. | Table 1 |

Other MATLAB scripts are provided in the `support_functions` and `support_functions_plot` folders, but the user is not supposed to interact with them.

