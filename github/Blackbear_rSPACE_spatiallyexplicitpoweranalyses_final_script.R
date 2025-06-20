# Spatially explicit simulations for black bears in New York State to determine minimum sampling requirements

# These simulations require you have the rSPACE source (contained with the repo) downloaded and program MARK downloaded and installed
# to download program MARK go to http://www.phidot.org/software/mark/downloads/


# Once you have program MARK installed you can install other required packages
# install.packages('RMark')
# install.packages('tcltk2')
# install.packages('C:/Users/twininjo/Documents/R/JAPPLE_rSPACE_occupancy_sims/rSPACE/rSPACE_1.2.2.tar.gz', repos = NULL, type="source")
# 

# load the require packages
library(rSPACE); library(raster); library(ggplot2); library(plyr)

#bobcat simulations
setwd("C:/yourworkingdirectory")

## read in the habitat map
bear_habitat_raster <- raster('bear_habitat_allNY.prop.tif')
bear_habitat_raster[is.na(bear_habitat_raster[])] <- 0

# Project Raster
sr <- "+proj=utm +zone=18 +datum=NAD83 +units=m +no_defs"

bear_projected_raster <- projectRaster(bear_habitat_raster, crs = sr)
bear_projected_raster[is.na(bear_projected_raster[])] <- 0

str(bear_projected_raster)


plot(bear_projected_raster)

## Home range area (sqkm) & radius (km)
HR <- c(45, 450)
HR.rad <- sqrt(HR/pi)
## Input parameter list
FixedParameters<-list(
  MFratio = c(.29, .71), ## Ratio of types of individuals
  buffer = HR.rad*2, ## Distance between centers
  moveDist = HR.rad, ## Movement radius
  moveDistQ = c(.9,.7), ## Proportion of movements in radius
  maxDistQ = c(.95,.95), ## Truncation for long-dist movements
  grid_size = c(30), ## Cell size in grid (sqkm)
  habitat.cutoff = .62, ## Min. quality value = habitat
  sample.cutoff = 0.01, ## Min. proportion of habitat pixels
  n_visits = 8, ## Max. number of visits per year
  n_visit_test = c(4,6,8), ## Number of visits per year
  detP_test = c(.1, .2, .4, .6), ## Per-visit detection|presence
  grid_sample = seq(.05,.95,.1), ## Proportion of grid to sample
  alt_model = 0) ## Alternative year sampling models

## dataframe of scenarios
## Set different population abundance change scenarios magnitudes to simulate
scenario <- expand.grid(
  mag = c(.25,.50), # magnitude of population abundance change
  dir = c(1,-1), # direction of population change
  n_yrs = c(5,10), # duration of population change (years)
  N = c(5000, 8000)) # starting abundance (N_t=1)

scenario["lmda"] <- (1+scenario$dir*scenario$mag)^(1/scenario$n_yrs)

## dataframe of scenarios
for(j in 1:nrow(scenario)){
  ScenParameters <- FixedParameters
  ScenParameters[c("N","lmda","n_yrs")] <- scenario[j,c("N","lmda","n_yrs")]
  createReplicates(n_runs=100, map=bear_projected_raster, Parameters=ScenParameters,
                   run.label=paste0("sims/blackbear_sims",j),skipConfirm=T, overwrite=T)
  testReplicates(paste0("./sims/blackbear_sims",j), Parameters=ScenParameters,
                 overwrite=T,skipConfirm=T)
}

Results<-list()
for(j in 1:nrow(scenario)){
  Results[[j]]<-getResults(paste0("sims/blackbear_sims",j),
                           CI=0.99, returnData=2, plot=F)
  ## Add identifying info for each scenario
  Results[[j]]<-data.frame(Results[[j]],scenario[j,c("N","lmda","mag","n_yrs")])
}
## combine results into one data.frame
Results<-rbind.fill(Results)

table(Results$n_grid)

bear <- Results

write.csv(Results, 'blackbear_rSPACE_sims_results_99CIs.csv')
