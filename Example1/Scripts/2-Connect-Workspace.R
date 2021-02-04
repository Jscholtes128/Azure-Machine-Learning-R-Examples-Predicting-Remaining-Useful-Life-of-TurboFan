library(azuremlsdk)

interactive_auth <- interactive_login_authentication()

ws <- get_workspace(name="AzureML",
                    subscription_id="",
                    resource_group="",
                    auth=interactive_auth)

write_workspace_config(ws)
