remove(list = ls())

# defineArgs --------------------------------------------------------------

source('D:/Applications/R/william stobart/dataread/defineArgs.R', echo= FALSE)


# MAPs and Data -----------------------------------------------------------

source('D:/Applications/R/william stobart/dataread/readFiles.R', echo= FALSE)

# Modify Data

source('D:/Applications/R/william stobart/dataread/prepareData.R', echo= FALSE)

remove(list = ls(pattern = "^temp"))
