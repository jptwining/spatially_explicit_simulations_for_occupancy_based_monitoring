# Spatially explicit simulations for bobcats in New York State to determine minimum sampling requirements

# These simulations require you have the rSPACE source (contained with the repo) downloaded and program MARK downloaded and installed
# to download program MARK go to http://www.phidot.org/software/mark/downloads/

# 
# # Once you have program MARK installed you can install other required packages
# install.packages('RMark')
# install.packages('tcltk2')
# install.packages('./rSPACE_1.2.2.tar.gz', repos = NULL, type="source")
# 

# load the require packages
library(rSPACE); library(raster); library(ggplot2); library(plyr)

#bobcat simulations
setwd("C:/yourworkingdirectory")

## read in the habitat map
bobcat_psi_raster <- raster("NY_30km_grid_bobcat_preds.tif")
str(bobcat_psi_raster)

# Define the CRS
sr <- "+proj=utm +zone=18 +datum=NAD83 +units=m +no_defs"

# Project Raster
bobcat_raster <- projectRaster(bobcat_psi_raster, crs = sr)
str(bobcat_raster)

bobcat_raster <- bobcat_raster
bobcat_raster[is.na(bobcat_raster[])] <- 0
plot(bobcat_raster)
str(bobcat_raster)

## Home range area (km^2) & radius (km) for movement parameters
HR <- c(30, 90)
HR.rad <- sqrt(HR/pi)

## Input parameter list
FixedParameters<-list(
  MFratio = c(.54,.46), ## Sex-ratios (males to female)
  buffer = HR.rad*2, ## Intra-sexual buffer distances between activity centers
  moveDist = HR.rad, ## Movement distance for UD calculations of individuals 
  moveDistQ = c(.9,.7), ## Proportion of movements in radius
  maxDistQ = c(.95,.95), ## Truncation for long-dist movements
  grid_size = 30, ## Cell size in grid (km^2)
  habitat.cutoff = .1, ## Minimum raster value for ACs to occur in grid cells
  sample.cutoff = 0.01, ## Minimum proportion of habitat pixels to be sampled
  n_visits = 8, ## Max. number of visits per year
  n_visit_test = c(4, 6, 8), ## Number of visits per year
  detP_test = c(.05, .1, .2, .4), ## Per-visit detection|presence
  grid_sample = seq(.05,.95,.1), ## Proportion of grid to sample
  alt_model = 0) ## Alternative models

## Set different population abundance change scenarios magnitudes to simulate
scenario <- expand.grid(
  mag = c(.25,.50), # magnitude of population abundance change
  dir = c(1,-1), # direction of population change
  n_yrs = c(5,10), # duration of population change (years)
  N = c(1000, 5000)) # starting abundance (N_t=1)

## calculate lambda based on population direction and change
scenario["lmda"] <- (1+scenario$dir*scenario$mag)^(1/scenario$n_yrs)


# create a dataframe of scenarios and run the simulations (be patient, theres a lot of scenarios!)
for(j in 1:nrow(scenario)){
  ScenParameters <- FixedParameters
  ScenParameters[c("N","lmda","n_yrs")] <- scenario[j,c("N","lmda","n_yrs")]
  createReplicates(n_runs=100, map=bobcat_raster, Parameters=ScenParameters,
                   run.label=paste0("sims/bobcat_sims",j), skipConfirm=T, overwrite=T)
  testReplicates(paste0("./sims/bobcat_sims",j), Parameters=ScenParameters,
                 overwrite=T, skipConfirm=T)
}

# create list to pull results into
Results<-list()
for(j in 1:nrow(scenario)){
  Results[[j]]<-getResults(paste0("sims/bobcat_sims",j),
                           CI=0.99, returnData=2, plot=F)
  ## Add identifying info for each scenario
  Results[[j]]<-data.frame(Results[[j]],scenario[j,c("N","lmda","mag","n_yrs")])
}

# combine results into one data.frame
Results<-rbind.fill(Results)

bobcat <- Results


write.csv(bobcat, 'bobcat_rSPACE_sims_results_99CIs.csv')

