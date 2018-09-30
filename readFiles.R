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

if (args.TEMP.DATA.UPDATE == T){
  tempFun.writeFeather(args.DATA.PATH, args.TRAFFIC.DATA.FOLDERNAME) # update dataset
}
my_data <- feather::read_feather(file.path(default_data_path,
                                           default_traffic_data_foldername,
                                           'trafficData.feather'))

