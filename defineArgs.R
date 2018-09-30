# Set the file path saving all data of the company 
args.DATA.PATH <- "D:/Applications/R/william stobart/ws_data"

# subfolders: "traffic_data" all the company's data based on week
args.TRAFFIC.DATA.FOLDERNAME <- "traffic_data"

# Area and PostCode
args.AREA.POSTCODE <- read.csv(file.path(default_data_path, "sysdata", "area_and_postcode.csv"))

# install packages
args.PKG <- c("tidyverse", 
              "readxl", 
              "feather")
pkgStatus <- suppressWarnings(lapply(args.PKG, require, quietly = T, character = T))
if (!all(as.logical(pkgStatus))){
  stop(paste0("Packages not loaded:", pkg[!as.logical(pkgStatus)])) # Print not loaded packages
}

# Update Data?
default_dataupdate <- F

