# Spatially explicit simulations for multi-species occupancy based monitoring

# Summary
Within this repository are files and scripts to enable users to conduct spatially explicit simulations to examine occupancy-based sampling designs ability to achieve power to detect changes in population abundance using established tools.

Contained within this repository are:
1. Files which include a tar file containing the rSPACE package for R, as well as raster maps for habitat suitability for New York for bobcats, black bears, and marten.
2. Scripts which include code to run spatially explicit simulations using the above files to assess sampling requirements to achieve power to detect 25-50% population abundance changes for bobcats, black bear, and marten in New York State.  

## The working directory

Below you will find descriptions of each folder in this repository and files contained within them.

## The folder directory (./main/Files/...)

This folder has two subfolders

## 1. The files needed to run the associated R scripts (./main/Files)

### 1.1. rSPACE_1.2.2.tar.gz

This tar contains all the files needed to install the rSPACE package in R

### 1.2. NY_30km_grid_bobcat_preds.tif

This tif file is a raster map of New York State at a 30 km^2 spatial-scale, the values of each cell in this raster are the probability of occupancy (psi) for bobcats based on predictions models from Twining et al. 2024a (https://www.sciencedirect.com/science/article/pii/S0006320723004998) and NLCD landscape covariate values. 

### 1.3. NZ_6km_grid_marten_preds.tif

This tif file is a raster map of northern New York State (Adirondacks and Tug Hill region) at a 6 km^2 spatial scale, the values of each cell in this raster are the probability of occupancy (psi) for American marten based on predictions models from Twining et al. 2024b (https://nsojournals.onlinelibrary.wiley.com/doi/10.1111/oik.10577?af=R) and NLCD landscape covariate values.

### 1.4. bear_habitat_allNY.prop.tif

This tif file is a raster map of New York State using a 30 km^2 spatial-scale, the values of each raster are values for total forest cover in each cell based on NLCD data.

## 2. The scripts for running the spatially explicit simulation scenarios for each species (./main/Scripts)

### 2.1. Bobcat_Spatiallyexplicitpoweranalyses_final_script.R

This script installs required packages and runs spatially explicit simulations for a variety of abundance, detection probability, and magnitude of change scenarios (1920 scenarios in total) for bobcats in New York State

### 2.2. Marten_rSPACE_spatiallyexplicitpoweranalyses_final_script.R

This script installs required packages and runs spatially explicit simulations for a variety of abundance, detection probability, and magnitude of change scenarios (1920 scenarios in total) for marten in New York State

### 2.3. Blackbear_rSPACE_spatiallyexplicitpoweranalyses_final_script.R

This script installs required packages and runs spatially explicit simulations for a variety of abundance, detection probability, and magnitude of change scenarios (1920 scenarios in total) for black bears in New York State
