
library(downloader)
library(dplyr)


# Download Data
url = "https://ti.arc.nasa.gov/c/6/"

download(url, dest="CMAPSSData.zip", mode="wb")
unzip("CMAPSSData.zip", "train_FD001.txt",exdir = ".")

cols = c("unit","cycle","os1","os2","os3","sm1","sm2","sm3","sm4","sm5","sm6","sm7","sm8","sm9","sm10","sm11","sm12","sm13","sm14","sm15","sm16","sm17","sm18","sm19","sm20","sm21")

# Load Extracted Turbo Fan Data
data = read.table(file="train_FD001.txt",header=FALSE,col.names = cols)

# Calculate Remaining Useful Life
data = data %>%
  group_by(unit) %>%
  mutate(rul = max(cycle)-cycle)

write.csv(data,'./data/turbofan.csv',row.names = FALSE)

file.remove("CMAPSSData.zip")
file.remove("train_FD001.txt")






