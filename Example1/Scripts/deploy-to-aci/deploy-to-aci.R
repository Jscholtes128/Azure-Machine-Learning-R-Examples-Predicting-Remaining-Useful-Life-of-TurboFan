library(azuremlsdk)
library(jsonlite)
library(dplyr)


ws <- load_workspace_from_config()

exp <- experiment(ws,"turbofan-rscript")

#runs = get_runs_in_experiment(exp)



####################
## Register Model ##
####################

#Get model from run
run <- get_run(exp,'turbofan-rscript_1612375539_02d51f89')

# Register the model
model <- register_model_from_run(run,model_path = "./outputs/turbofan.rds", model_name = "turbofan.rds")




####################
## Deploy Model   ##
####################

# Create environment
packages<- list(cran_package(name="gbm"),cran_package(name="ggplot"))


r_env <- r_environment(name = 'r_env',
                       version = '1',cran_packages = packages) 


# Create inference config
inference_config <- inference_config(
  entry_script = "score.R",
  source_directory = ".",
  environment = r_env)

# Create ACI deployment config
deployment_config <- aci_webservice_deployment_config(cpu_cores = 1,
                                                      memory_gb = 1)

# Deploy the web service
service_name <- paste0('aciwebservice-', sample(1:100, 1, replace=TRUE))
service <- deploy_model(ws, 
                        service_name, 
                        list(model), 
                        inference_config, 
                        deployment_config)
wait_for_deployment(service, show_output = TRUE)


# If you encounter any issue in deploying the webservice, please visit
# https://docs.microsoft.com/en-us/azure/machine-learning/service/how-to-troubleshoot-deployment


get_webservice_logs(service)



#################
##  Test Model ##
#################

default_ds <- get_default_datastore(ws)

ds <- get_dataset_by_name(ws,'turbofan dataset')
nasa <- load_dataset_into_data_frame(ds)

smpl <- sample_n(nasa, 5)
test_smpl <- select(smpl,-c(rul))




# Test the web service
predicted_val <- invoke_webservice(service, toJSON(smpl))
predicted_val

# Delete the web service
#delete_webservice(service)
