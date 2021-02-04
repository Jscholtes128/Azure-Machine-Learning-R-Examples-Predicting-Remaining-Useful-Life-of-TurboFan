# Azure Machine Learning R Examples - Predicting Remaining Useful Life of TurboFan

![](/media/ac3d10d90b9df74255594d931691e127.png)

## Sample 1 - Starting Azure Machine Learning from local IDE 

- [Azure Machine Learning R Examples - Predicting Remaining Useful Life of TurboFan](#azure-machine-learning-r-examples---predicting-remaining-useful-life-of-turbofan)
  - [Sample 1 - Starting Azure Machine Learning from local IDE](#sample-1---starting-azure-machine-learning-from-local-ide)
  - [Prerequisites](#prerequisites)
  - [R files for data prep, train, track experiments, and deploy model:](#r-files-for-data-prep-train-track-experiments-and-deploy-model)
    - [1-DataPrep.R](#1-dataprepr)
    - [2-Connect-Workspace.R](#2-connect-workspacer)
    - [3-Train-Local-With-Logging.R](#3-train-local-with-loggingr)
    - [4-AML-Register-DataStore.R](#4-aml-register-datastorer)
    - [Remote Training](#remote-training)
    - [Model Register/Deployment](#model-registerdeployment)

## Prerequisites
Set-up on Azure Portal:
<br/>
 - [Create and manage Azure Machine Learning workspaces in the Azure portal](https://docs.microsoft.com/en-us/azure/machine-learning/service/how-to-manage-workspace)
<br/><br/>
- [Install Azure ML SDK from CRAN](https://github.com/Azure/azureml-sdk-for-r#installation)


## R files for data prep, train, track experiments, and deploy model:

### [1-DataPrep.R](/Example1/Scripts/1-DataPrep.R)
Download Turbofan data, unzip, add RUL (remaining useful life) column and save as csv

### [2-Connect-Workspace.R](/Example1/Scripts/2-Connect-Workspace.R)
Connect to Azure Machine Learning Workspace and store config file.

### [3-Train-Local-With-Logging.R](/Example1/Scripts/3-Train-Local-With-Logging.R)
Extend a local training file to track training experiments with Azure Machine Learning Service.

### [4-AML-Register-DataStore.R](/Example1/Scripts/4-AML-Register-DataStore.R)
Register and version control the NASA turbofan dataset with Azure Machine Learning Datasets.

### [Remote Training](/Example1/Scripts/train-remote/)
Create Azure Machine Learning compute to remote train models.

### [Model Register/Deployment](/Example1/Scripts/deploy-to-aci/)
Register your model to Azure Machine Lerning and then deploy to ACI (Azure Container Instance) for real-time predictions.

