# Set the file path saving all data of the company 
args.DATA.PATH <- "D:/Applications/R/william stobart/ws_data"

# subfolders: "traffic_data" all the company's data based on week
args.TRAFFIC.DATA.FOLDERNAME <- "traffic_data"

# update the data or map in the folder
args.TEMP.DATA.UPDATE <- F
args.TEMP.MAP.UPDATE <- F

# Area and PostCode
args.POSTAREA.TRAFFICAREA <- read.csv(file.path(args.DATA.PATH, "sysdata", "postarea_and_trafficearea.csv"))
args.POSTATEA.CITY <- read.csv(file.path(args.DATA.PATH, "sysdata", "postarea_and_city.csv"))

# install packages
args.PKG <- c("tidyverse", 
              "readxl", 
              "feather",
              "leaflet")
pkgStatus <- suppressWarnings(lapply(args.PKG, require, quietly = T, character = T))
if (!all(as.logical(pkgStatus))){
  stop(paste0("Packages not loaded:", pkg[!as.logical(pkgStatus)])) # Print not loaded packages
}


