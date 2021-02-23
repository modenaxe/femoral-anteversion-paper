[![DOI](https://zenodo.org/badge/337821512.svg)](https://zenodo.org/badge/latestdoi/337821512)

# Table of contents <!-- omit in toc -->

- [Overview](#overview)
- [Brief summary of the publication](#brief-summary-of-the-publication)
- [Requirements and setup](#requirements-and-setup)
- [Resources included in this repository](#resources-included-in-this-repository)
- [Available MATLAB scripts](#available-matlab-scripts)
- [Limitations and notes about reproducibility](#limitations-and-notes-about-reproducibility)
- [Future work](#future-work)


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
The paper is available [as preprint](https://biorxiv.org/cgi/content/short/2021.02.22.432159v1).

# Brief summary of the publication

In our manuscript: 
* We presented a MATLAB tool for applying torsional profiles to the bones of generic musculoskeletal models in OpenSim format. This tool is openly developed [at this link](https://github.com/modenaxe/msk_bone_deformation).
* We investigated how the joint reaction forces in a musculoskeletal model of the lower limb change when the femoral anteversion of that model is modified.
* We assessed the results of our simulations against the in vivo measurements of knee loads available at https://simtk.org/projects/kneeloads for patient 5. </br>

![paper_overview](/images/paper_results.png)

# Requirements and setup

In order to take full advantage of the content of this repository you will need to:
1. download [OpenSim 3.3](https://simtk.org/projects/opensim). Go to the `Download` page of the provided link and click on `Previous releases`, as shown in [this screenshot](https://github.com/modenaxe/3d-muscles/blob/master/images/get_osim3.3.PNG).
2. have MATLAB installed in your machine. The analyses of the paper were performed using version R2020a.
3. set up the OpenSim 3.3 API. Required to run the provided scripts. Please refer to the OpenSim [documentation](https://simtk-confluence.stanford.edu/display/OpenSim/Scripting+with+Matlab).
4. (optional) [NMSBuilder](http://www.nmsbuilder.org). NMSBuilder can be used to visualize how the femoral anteversion was estimated in the femoral geometries of the baseline model and in the segmented femur of the GC5 patient.
5. clone this repository together with the bone-deformation submodule using the following command on git:
```bash
git clone --recursive https://github.com/modenaxe/femoral_anteversion_paper.git
```
or if you have cloned it without the recursive option please refer to [this post](https://stackoverflow.com/questions/25200231/cloning-a-git-repo-with-all-submodules) and use:
```bash
git submodule init
git submodule update
```

# Resources included in this repository
This repository includes:
1. [`1_scale_model` folder](/1_scale_model):aA [full-body OpenSim model](https://simtk.org/projects/full_body/) that was reduced removing the arms and scaled to the anthropometrics of the fifth patient of the [Grand Challenge Competition to Predict In Vivo Knee Loads](https://simtk.org/projects/kneeloads).
2. [`2_make_knee_weaker` folder](/2_make_knee_weaker): scripts to make the knee crossing the knee joint weaker by 40%. `GC5.osim` is the model resulting from this operation, which is referred to as the _baseline model_ in the manuscript.
3. [`3_deform_femur_l` folder](/3_deform_femur_l): script that generates models applying a femoral anteversion ranging from 2 degrees retroversion to 40 degrees anteversion. These are referred to as _modified models_ in the manuscript. The scripts depends on the [bone-deformation tool](https://github.com/modenaxe/msk_bone_deformation) that we have released with this publication. The bone geometries produced by the tool are available in the [Geometry folder](/3_deform_femur_l/Geometry/) for model visualization.
4. [`4_run_simulations` folder](/4_run_simulations): contains all the results from the simulations run for this publication. Please note that some input files are common to simulations with all models, so they were stored in the `Common inputs` folder. These common inputs are: 
      * raw motion capture files (`c3d` folder, copied  from the [Grand Challenge website](https://simtk.org/projects/kneeloads),
      * marker files (`trc` folder) ,
      * joint kinematics (`IK` folder), 
      * ground reaction forces (`External Loads` folder). 
 The `Dataset` folder then contains a folder for each model, e.g. `GC5_FemAntev19Deg`, and each folder includes:
      * muscle forces and activations estimated by static optimization (`SO` subfolder),
      * joint reactions (`JR` subfolder)
      * matlab files collecting all the simulation results (`Mat_summary` subfolder)

5. [`5_analyze_results` folder](/5_analyze_results): includes scripts to analyze and plot the results of the simulations. Details of the scripts are presented in the next section. Other items are:
      * `2021-02-17_table_results.xls`: the table of results then reported in the paper. A version of this table is generated automatically by `analyze_JRFs.m`.
      * [`Figure2_wt_text`](/5_analyze_results/Figure_2_with_text): the Figure 2 included in the manuscript. A version of this figure is automatically generated by `plot_JRFs.m` and stored in the folder `5_analyze_results/Figure_2`.
      * `eTibia_data.mat`: a MATLAB file that stores in vivo medial and lateral forces for all patients of the Grand Challenge Competition to Predict In Vivo Knee Loads. It includes self-explicative column headers.

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

Other MATLAB scripts included in the repository are dependent functions.

# Limitations and notes about reproducibility

* All input, output and setup files required to run the simulations are provided, but not the workflow employed for running the simulations.
* Using the setup files might require adjusting the input/output folders to your local setup.

# Future work

* Upgrade scripts to openSim 4.x.
