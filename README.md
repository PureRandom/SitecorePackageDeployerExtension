# Sitcore Package Deployer for Azure DevOps

With this task you can automatically run the Sitecore Package Deployer from AzureDevOps. Once it is running a report wil be fed back to the process so you can check when the process has finished before continuing with the deployment.

### Usage
To use this task you will need the Sitecore Package Deployer install on the Sitecore instance you wish to run it again.

Also check that Azure DevOps can request your Sitecore instance's URL, so it can trigger teh Sitecore Pakage Deployer.

**Task Fields**

SitecoreUrl <br/>
This is your Sitecore instance base url e.g. https://www.mywebsite.com

Force <br/>
This will force the Sitecore Package Deployer to run even if it is busy.

CheckPackageComplete<br/>
This will monitor the Sitecore Package Deployer Folder for it progress in processing the update packages.

SitecorePackageDeployerPath <br/>
This is the location where the Update files will be deployed e.g. /data/SitecorePackageDeployer.

### Further Information
- Team Development for Sitecore - [Sitecore Package Deployer](https://www.teamdevelopmentforsitecore.com/Blog/sitecore-package-deployer)
- Christopher Pateman - [PR Code](https://prcode.blog)

### Legal
This is not an offical task by Team Development for Sitecore or sponsored. This extension is produced independently of Team Development for Sitecore.
