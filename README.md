# Overview

This repository contains the data, models and the MATLAB scripts to inspect and reproduce the results of the following publication:

```bibtex
@article{Modenese2021bonedef,
  title={Dependency of Lower Limb Joint Reaction Forces on Femoral Anteversion},
  author={Luca Modenese, Martina Barzan and Christopher P. Carty},
  journal={Gait & Posture},
  volume = {submitted},
  year={2021},
  keywords = {Anteversion, Musculoskeletal modeling, Tibiofemoral contact force, Knee Loading, Femur, Walking}
}
```
The paper is available [as preprint - LINK TO BE ADDED]().

# Brief summary of the publication

In our manuscript: 
* We presented a MATLAB tool for applying torsional profiles to the bones of generic musculoskeletal models in OpenSim format. This tool is openly developed [at this link](https://github.com/modenaxe/msk_bone_deformation).
* We investigated how the joint reaction forces in a musculoskeletal model of the lower limb change when the femoral anteversion of that model is modified.
* We assessed the results of our simulations against the in vivo measurements of knee loads available at https://simtk.org/projects/kneeloads for patient 5. 

# Available MATLAB scripts

The provided MATLAB scripts allow the reader to reproduce the results and figures included in the manuscript. The most relevant scripts are described in the following table:

| Script name | Script action | Related item in the manuscript|
| --- | --- | --- |
| `make_knee_muscle_weaker.m` | reduces the strenght of knee-spanning muscles in the specified model by 40%. Depends on `getJointsSpannedByMuscle.m` | N/A |
| `create_femAnt_models.m` | creates OpenSim model with the specified range of femoral anteversion angles. The baseline model has a femoral anteversion angle of 12 degrees. Depends on the bone-deformation toolbox in the `msk_bone_deformation` folder| N/A |
| `step1_create_dataset.m` | arranges contents of folders for running the simulations (only results are provided). | N/A |
| `save_mat_summaries.m` | converts the simulation results in a format usable for further analyses. | N/A |
| `plot_JRFs.m` | plots the joint reaction forces obtained from simulations with models having different femoral anteversion. | Figure 2. |
| `analyze_JRFs.m` | runs basic analyses on the joint reaction forces resulting from the simulations. | Table 1 |

Other MATLAB scripts included in the repository are dependencies of these main scripts.

