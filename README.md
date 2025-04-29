# Azure DevOps Pipeline Boost - replace for Docker Containers? (Replace for not properly configured CI/CD)

![GitHub stars](https://img.shields.io/github/stars/damianczer/azure-devops-msbuild-auto?style=social) <br>
![GitHub watchers](https://img.shields.io/github/watchers/damianczer/azure-devops-msbuild-auto?style=social) <br>
![GitHub issues](https://img.shields.io/github/issues/damianczer/azure-devops-msbuild-auto?style=flat-square) <br>

**Authors:** [Damian Czerwiński](https://github.com/damianczer/)

Technology: <br><br>
PowerShell  - https://learn.microsoft.com/en-us/powershell/ <br> 
MSBuild - https://learn.microsoft.com/en-us/visualstudio/msbuild/?view=vs-2022 <br>
Azure DevOps & Pipeline - https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops <br>
CI/CD - https://learn.microsoft.com/en-us/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture?view=azure-devops

Script optimizes **CI/CD** and improves software delivery performance. **MsBuild** accepts as input a soluition file, which can contain up to hundreds of projects, this means that every attempt to deliver a software package to some host has to end with building the entire solution? <br>

Even if I have a small change in one project?
<br>

Well, no!<br>

The script detects what changes have occurred compared to the indicated branch, example: we are working on a **feature branch** - then we create a **pull request to the develop** and **from the develop we push(build)** the package to the server. So, the develop will compare to the **master** and build selected projects from the solution - those that need rebuilding. As it turns out, it speeds up the work a lot. <br>

This solution has its conditions - **the main application may be in legacy projects where CI/CD does not work according to the art and there is no budget for its configuration**.

Is just an example of a solution - it can be customized for the specifics of the project.

Do you have a **BIG** solution? <br />
More than **100** projects? <br />
Don't you use **Docker Containers** or **CI/CD** and have to build the whole solution? <br />
Does it take a lot of time to build the entire solution through **Pipeline Azure DevOps**? <br />
Are you waiting more than **20 minutes** even the changes were minimal? <br />

Here is the Solution! <br />

Before:

![image](https://github.com/user-attachments/assets/8f72e8f9-7fcf-4d71-9df4-f183edb814d9)

After:

![image](https://github.com/user-attachments/assets/5e4e6e01-9a2e-46bd-8d34-cfdec00700ec)

(Almost 20 minutes less)

Step Configuration:

![image](https://github.com/user-attachments/assets/446de0d0-5a15-41ef-8f04-c93038bb91e4)

Pipeline Variables:

![image](https://github.com/user-attachments/assets/2106bb8b-8bea-4547-80a3-7f95292a5488)

MSBuild Configuration:

![image](https://github.com/user-attachments/assets/b4f653cf-312c-47dd-8bce-5c26afea8ac4)

Call **MSBuild** inside **Build.proj** with our global variable (list of changed projects) instead of Solution File (.sln):

![image](https://github.com/user-attachments/assets/72fd32b6-4f1c-41cb-b460-f48729d5b1bf)

If your deployment method allows you to _"copy only changed files/projects/.dlls"_ -> **let's do it!** Don't build the whole soloution, build what has changed! If the projects are dependent on each other - references will be built! This is just a proposal for a solution/optimization of software delivery to the client server.

Enjoy!
