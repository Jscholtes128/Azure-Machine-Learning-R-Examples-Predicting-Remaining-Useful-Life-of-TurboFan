library(jsonlite)
library(gbm)

init <- function()
{
  model_path <- Sys.getenv("AZUREML_MODEL_DIR")
  model <- readRDS(file.path(model_path, "turbofan.rds"))
  message("model is loaded")
  
  function(data)
  {
    nasa <- as.data.frame(fromJSON(data))
    prediction <- predict(model, newdata=nasa, n.trees=10000, type="response")
    #predict(model, nasa)
    result <- as.character(prediction)
    toJSON(result)
  }
}