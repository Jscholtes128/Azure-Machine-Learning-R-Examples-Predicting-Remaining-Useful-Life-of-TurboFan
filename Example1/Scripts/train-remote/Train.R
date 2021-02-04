library(azuremlsdk)
library(gbm)
library(ggplot2)
library(optparse)

options <- list(
  make_option(c("-d", "--data_folder"))
)

opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

paste(opt$data_folder)


nasa <- read.csv(file.path(opt$data_folder, "turbofan.csv"))


smp_size <- floor(0.70 * nrow(nasa))

## set the seed to make your partition reproducible
set.seed(123)
train_ind <- sample(seq_len(nrow(nasa)), size = smp_size)

nasa_train <- nasa[train_ind, ]
nasa_test <- nasa[-train_ind, ]


gbm.fit <- gbm(
  formula = rul ~ .,
  distribution = "gaussian",
  data = nasa_train,
  n.trees = 10000,
  interaction.depth = 1,
  shrinkage = 0.001,
  cv.folds = 5,
  n.cores = NULL,
  verbose = FALSE
)  

# print results
print(gbm.fit)

rmse = sqrt(min(gbm.fit$cv.error))

log_metric_to_run('RMSE', rmse)

png(filename="gbm_perf.png", 
    units="px", 
    width=1800, 
    height=1200,
    pointsize = 24)
gbm.perf(gbm.fit, method = "cv")
dev.off()

log_image_to_run(name = "GBM Perf",path = "gbm_perf.png")


model_file_name = './outputs/turbofan.rds'


saveRDS(gbm.fit, model_file_name)




