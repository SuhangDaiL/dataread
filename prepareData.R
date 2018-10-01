summary(data.Traffic)
tempData <- data.Traffic 
tempData.names <- names(tempData)

# Time, Location, Distance, Cost, Revenue?
# Categorical: Customer? Jobtype?


tempData <- tempData[c("Start Date", "FinishDate", "Cust Code" , "Coll Dpt", 
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



temp <- format(data.Traffic$`Coll Time`, format = "%H:%M:%S")
names(data.Traffic)