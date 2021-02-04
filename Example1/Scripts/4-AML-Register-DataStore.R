library(azuremlsdk)
library(tools)



## Save Dataset

ws <- load_workspace_from_config()


default_ds <- get_default_datastore(ws)

ds <- tryCatch(get_dataset_by_name(ws,'turbofan dataset'),
               error = function(e)
                 NULL)

if(is.null(ds)){
  
  upload_to_datastore(src_dir = "./Scripts/data",
                            datastore = default_ds,
                            target_path = 'turbofan-demo/',
                            overwrite = TRUE,
                            show_progress = TRUE)
  
  dp <-data_path(datastore = default_ds,path_on_datastore = "turbofan-demo/*.csv")
  
  ds <- create_tabular_dataset_from_delimited_files(path =dp )
  
  register_dataset(workspace = ws,dataset = ds,name ="turbofan dataset",description ="turbofan data" ,tags = list('format'='CSV'),create_new_version = TRUE)


print('Dataset registered.')

}else{
  print('Dataset already registered.')
}