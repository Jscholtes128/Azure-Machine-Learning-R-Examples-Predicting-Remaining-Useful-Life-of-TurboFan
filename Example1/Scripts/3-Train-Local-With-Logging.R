library(azuremlsdk)
library(gbm)
library(ggplot2)

ws <- load_workspace_from_config()

#default_ds <- get_default_datastore(ws)

#ds <- get_dataset_by_name(ws,'turbofan dataset')
#nasa <- load_dataset_into_data_frame(ds)

nasa = read.csv('./data/turbofan.csv')

smp_size <- floor(0.70 * nrow(nasa))

## set the seed to make your partition reproducible
set.seed(123)
train_ind <- sample(seq_len(nrow(nasa)), size = smp_size)

nasa_train <- nasa[train_ind, ]
nasa_test <- nasa[-train_ind, ]

experiment_name <- "turbofan-rscript"
exp <- experiment(ws, experiment_name)

run <- start_logging_run(exp)

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

log_metric_to_run('RMSE', rmse,run=run)

png(filename="gbm_perf.png", 
    units="px", 
    width=1800, 
    height=1200,
    pointsize = 24)
gbm.perf(gbm.fit, method = "cv")
dev.off()

log_image_to_run(name = "GBM Perf",path = "gbm_perf.png",run=run)

model_file_name = './outputs/turbofan.rds'

saveRDS(gbm.fit, model_file_name)

upload_folder_to_run('outputs',path = 'outputs',run)

complete_run(run=run)

smpl <- sample_n(nasa, 5)
test_smpl <- select(smpl,-c(rul))
predict(gbm.fit, newdata=test_smpl, n.trees=10000, type="response")
