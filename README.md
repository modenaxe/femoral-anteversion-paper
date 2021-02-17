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

# Requirements and setup

In order to take full advantage of the content of this repository you will need to:
1. download [OpenSim 3.3](https://simtk.org/projects/opensim). Go to the `Download` page of the provided link and click on `Previous releases`, as shown in [this screenshot](https://github.com/modenaxe/3d-muscles/blob/master/images/get_osim3.3.PNG).
2. have MATLAB installed in your machine. The analyses of the paper were performed using version R2020a.
3. set up the OpenSim 3.3 API. Required to run the provided scripts. Please refer to the OpenSim [documentation](https://simtk-confluence.stanford.edu/display/OpenSim/Scripting+with+Matlab).
4. (optional) [NMSBuilder](http://www.nmsbuilder.org). NMSBuilder can be used to visualize how the femoral anteversion was estimated in the femoral geometries of the baseline model and in the segmented femur of the GC5 patient.
6. clone this repository together with the STAPLE submodule using the following command on git:
```bash
git clone --recursive https://github.com/modenaxe/auto-lowerlimb-models-paper.git
```
or if you have cloned it without the recursive option please refer to [this post](https://stackoverflow.com/questions/25200231/cloning-a-git-repo-with-all-submodules) and use:
```bash
git submodule init
git submodule update
```

# Resources included in this repository
This repository includes:
1. 

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

# Limitations and notes about reproducibility

* All input, output and setup files required to run the simulations are provided, but not the workflow employed for running the simulations.
* Using the setup files might require adjusting the input/output folders to your local setup.

# Future work

* Upgrade scripts to openSim 4.x.
