tempData.Traffic <- data.Traffic[c("Start Date", "FinishDate", "Cust Code" , "Coll Dpt", 
                       "Del Dpt", "Coll PCode", "Del PCode", "Distance","Job Type", 
                       "Revenue")]

# Date, y,w,m,d 
# PCode:  trafficarea, postarea, postdist, x, y, city
# Cumulative value: cost, distance, price
# Countable value: Job Type, Cust Code
splitPostCode <- function(pc, matchPart = NULL, data = NULL){
  temp <- str_trim(pc)
  temp <- str_split_fixed(temp, " ", n =2)
  temp.p1 <- temp[,1]
  temp.p2 <- temp[,2]
  temp.l1 <- str_locate(temp.p1, "\\d")[,1]
  temp.l2 <- str_locate(temp.p2, "\\d")[,2]
  temp.p1s <- str_sub(temp.p1, end = temp.l1-1)
  temp.p1d <- str_sub(temp.p1, start = temp.l1)
  temp.p1s[is.na(temp.p1s)] <- temp.p1[is.na(temp.p1s)]
  temp.p1d[is.na(temp.p1s)] <- ""
  temp.p2d <- str_sub(temp.p2, end = temp.l2)
  temp.p2s <- str_sub(temp.p2, start = temp.l2+1)
  temp.p2s[is.na(temp.p2s)] <- temp.p2[is.na(temp.p2s)]
  temp.p2d[is.na(temp.p2s)] <- ""
  miss.index <- seq(1,length(pc))[temp.p1d == "" | temp.p1s == "" | 
                    temp.p2d == "" | temp.p2s == ""]
  return(list(dist = str_c(temp.p1s, temp.p1d),
              area = str_c(temp.p1s),
              sect = str_c(temp.p1s, temp.p1d, " ", temp.p2d),
              warning = miss.index))
}

tempData <- tempData.Traffic
temp.cp <- splitPostCode(tempData$`Coll PCode`)
temp.dp <- splitPostCode(tempData$`Del PCode`)
# Remove the unnormal variables
tempData <- mutate( tempData, `Col_Area` = temp.cp$area, 
                    `Col_Dist` = temp.cp$dist, `Col_Sect` = temp.cp$sect) %>%
  mutate(`Del_Area` = temp.dp$area, 
         `Del_Dist` = temp.dp$dist, `Del_Sect` = temp.dp$sect)
temp.colpt <- data.frame(`Col_Area` = args.POSTAREA.TRAFFICAREA$postarea,
                         `Col_Traffic_Area` = args.POSTAREA.TRAFFICAREA$trafficarea)
temp.delpt <- data.frame(`Del_Area` = args.POSTAREA.TRAFFICAREA$postarea,
                         `Del_Traffic_Area` = args.POSTAREA.TRAFFICAREA$trafficarea)
tempData <- tempData[!seq(1,nrow(tempData)) %in% c(temp.cp$warning, temp.dp$warning),] %>%
  left_join(temp.colpt, by = "Col_Area") %>%
  left_join(temp.delpt, by = "Del_Area")
temp.colpt <- data.frame(`Col_Area` = args.POSTATEA.CITY$postarea,
                         `Col_City` = args.POSTATEA.CITY$city)
temp.delpt <- data.frame(`Del_Area` = args.POSTATEA.CITY$postarea,
                         `Del_City` = args.POSTATEA.CITY$city)
tempData <- tempData %>%
  left_join(temp.colpt, by = "Col_Area") %>%
  left_join(temp.delpt, by = "Del_Area")

#add map marker
temp.marker <- rgeos::gCentroid(args.MAP.SECT.MARKERONLY, byid = T)
temp.col <- data.frame(temp.marker@coords, "Col_Sect" = args.MAP.SECT.MARKERONLY@data$name)
colnames(temp.col) <- c("Col_long", "Col_lat", "Col_Sect")
temp.del <- data.frame(temp.marker@coords, "Dol_Sect" = args.MAP.SECT.MARKERONLY@data$name)
colnames(temp.del) <- c("Del_long", "Del_lat", "Del_Sect")
tempData <- tempData %>%
  left_join(temp.col, by = "Col_Sect") %>%
  left_join(temp.del, by = "Del_Sect")

#add map circle
temp.circle <- rgeos::gCentroid(args.MAP.DIST, byid = T)
temp.col <- data.frame(temp.circle@coords, "Col_Dist" = args.MAP.DIST@data$name)
colnames(temp.col) <- c("Col_long_Dist", "Col_lat_Dist", "Col_Dist")
temp.del <- data.frame(temp.circle@coords, "Dol_Dist" = args.MAP.DIST@data$name)
colnames(temp.del) <- c("Del_long_Dist", "Del_lat_Dist", "Del_Dist")
tempData <- tempData %>%
  left_join(temp.col, by = "Col_Dist") %>%
  left_join(temp.del, by = "Del_Dist")

data.Traffic <- tempData

data.Traffic$Del_Area <- factor(data.Traffic$Del_Area, levels = args.MAP.AREA@data$name)
data.Traffic$Col_Area <- factor(data.Traffic$Col_Area, levels = args.MAP.AREA@data$name)

data.Traffic$Del_Traffic_Area <- factor(data.Traffic$Del_Traffic_Area, levels = args.MAP.TRAFFICAREA@data$trafficarea)
data.Traffic$Col_Traffic_Area <- factor(data.Traffic$Col_Traffic_Area, levels = args.MAP.TRAFFICAREA@data$trafficarea)

data.Traffic$Del_Sect <- factor(data.Traffic$Del_Sect, levels = args.MAP.SECT.MARKERONLY@data$name)
data.Traffic$Col_Sect <- factor(data.Traffic$Col_Sect, levels = args.MAP.SECT.MARKERONLY@data$name)

data.Traffic$Del_Dist <- factor(data.Traffic$Del_Dist, levels = args.MAP.DIST@data$name)
data.Traffic$Col_Dist <- factor(data.Traffic$Col_Dist, levels = args.MAP.DIST@data$name)


data.Traffic <-  na.omit(data.Traffic)
# tempData.Traffic <- tempData
# 
# 
# 
# temp <- format(data.Traffic$`Coll Time`, format = "%H:%M:%S")
# names(data.Traffic)