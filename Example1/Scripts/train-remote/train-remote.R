library(azuremlsdk)


ws <- load_workspace_from_config()

ds <- get_default_datastore(ws)


packages<- list(cran_package(name="gbm"),cran_package(name="ggplot"))


r_env <- r_environment(name = 'r_env',
                       version = '1',cran_packages = packages) 



cluster_name <- "js-aml-compute"
compute_target <- get_compute(ws, cluster_name = cluster_name)
if (is.null(compute_target)) {
  vm_size <- "STANDARD_D2_V2"
  compute_target <- create_aml_compute(workspace = ws,
                                       cluster_name = cluster_name,
                                       vm_size = vm_size,
                                       max_nodes = 4)
  
  wait_for_provisioning_completion(compute_target, show_output = TRUE)
}



# Define estimator
est <- estimator(source_directory = ".",
                 entry_script = "Train.R",
                 script_params = list("--data_folder" = ds$path("turbofan-demo/")),
                 compute_target = compute_target ,
                 environment = r_env)
                 

# Initialize experiment
experiment_name <- "turbofan-rscript"
exp <- experiment(ws, experiment_name)

# Submit job and display the run details
run <- submit_experiment(exp, est)
plot_run_details(run)
wait_for_run_completion(run, show_output = TRUE)

# Get the run metrics
metrics <- get_run_metrics(run)
metrics