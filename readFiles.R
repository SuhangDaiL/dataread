# Read EXCEL file and Write feather ---------------------------------------

tempFun.writeFeather <- function(args.DATA.PATH, args.TRAFFIC.DATA.FOLDERNAME){
  traffic.Data.Path <- file.path(args.DATA.PATH, args.TRAFFIC.DATA.FOLDERNAME)
  filenames <- list.files(traffic.Data.Path)
  filenamesf <- filenames[grepl(".*.feather", filenames)]
  filenames <- filenames[grepl(".*.xlsx", filenames)]
  
  trafficData <- lapply(file.path(traffic.Data.Path, filenames), readxl::read_excel)
  trafficData.feather <- as.data.frame(bind_rows(trafficData, .id = "id"))
  
  f <- file.remove(file.path(traffic.Data.Path, filenamesf))
  feather::write_feather(trafficData.feather,
                         file.path(traffic.Data.Path, "trafficData.feather"))
}

if (args.TEMP.DATA.UPDATE){
  tempFun.writeFeather(args.DATA.PATH, args.TRAFFIC.DATA.FOLDERNAME) # update dataset
}
data.Traffic <- feather::read_feather(file.path(args.DATA.PATH,
                                           args.TRAFFIC.DATA.FOLDERNAME,
                                           'trafficData.feather'))


# MAP ---------------------------------------------------------------------

if (args.TEMP.DATA.UPDATE){
  source(file.path(args.DATA.PATH,'sysdata','readMap.R')) # update dataset
  source(file.path(args.DATA.PATH,'sysdata','updateMap.R'))
}
load(file = file.path(args.DATA.PATH, "sysdata", "ukmaps.rds"))
