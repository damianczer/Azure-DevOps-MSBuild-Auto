# 🚀 Azure DevOps Pipeline Boost  
**Optimize CI/CD for Legacy Projects Without Docker or Proper CI/CD Configuration**

![⭐ GitHub stars](https://img.shields.io/github/stars/damianczer/azure-devops-msbuild-auto?style=social)  
![👀 GitHub watchers](https://img.shields.io/github/watchers/damianczer/azure-devops-msbuild-auto?style=social)  
![🐞 GitHub issues](https://img.shields.io/github/issues/damianczer/azure-devops-msbuild-auto?style=flat-square)  

---

## 👤 **Author**  
[Damian Czerwiński](https://github.com/damianczer/)

---

## 🛠️ **Technology Stack**  
- **PowerShell** - [Documentation](https://learn.microsoft.com/en-us/powershell/)  
- **MSBuild** - [Documentation](https://learn.microsoft.com/en-us/visualstudio/msbuild/?view=vs-2022)  
- **Azure DevOps & Pipelines** - [Documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)  
- **CI/CD** - [Documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture?view=azure-devops)  

---

## 📝 **Overview**  
This script optimizes **CI/CD** pipelines by building only the projects that have changed, instead of rebuilding the entire solution. It is especially useful for:  
- **Large solutions** with **100+ projects**  
- **Legacy projects** without Docker or properly configured CI/CD  
- Reducing build times in **Azure DevOps Pipelines**  

---

## ⚡ **Why Use This Script?**  
- **Save Time:** ⏱️ Reduce build times by up to **20 minutes**!  
- **Selective Builds:** 🛠️ Build only the projects that have changed.  
- **Customizable:** 🔧 Adaptable to your project structure.  
- **Legacy-Friendly:** 🏛️ Works even without modern CI/CD tools like Docker.  

---

## 🛠️ **How It Works**  
1. **Detect Changes:** Compares the current branch with the target branch to identify changed files.  
2. **Filter Projects:** Extracts the list of projects (`.csproj`) affected by the changes.  
3. **Set Variables:** Passes the list of changed projects to MSBuild for selective building.  

---

## 📊 **Before vs After**  
### **Before:**  
Building the entire solution, even for small changes.  
![Before](https://github.com/user-attachments/assets/8f72e8f9-7fcf-4d71-9df4-f183edb814d9)  

### **After:**  
Building only the changed projects.  
![After](https://github.com/user-attachments/assets/5e4e6e01-9a2e-46bd-8d34-cfdec00700ec)  

---

## 🛠️ **Setup Instructions**  
1. Clone the repository.  
2. Configure the script parameters:  
   - `CompareSourceBranch`  
   - `BranchName`  
   - `Repository`  
   - `TargetBranch`  
3. Run the script in your Azure DevOps pipeline.  

---

## 📦 **Pipeline Configuration**  
### **Step Configuration:**  
![Step Configuration](https://github.com/user-attachments/assets/446de0d0-5a15-41ef-8f04-c93038bb91e4)  

### **Pipeline Variables:**  
![Pipeline Variables](https://github.com/user-attachments/assets/2106bb8b-8bea-4547-80a3-7f95292a5488)  

### **MSBuild Configuration:**  
![MSBuild Configuration](https://github.com/user-attachments/assets/b4f653cf-312c-47dd-8bce-5c26afea8ac4)  

---

## 🧩 **How to Use MSBuild with This Script**  
Instead of building the entire solution (`.sln`), pass the list of changed projects to MSBuild:  
```xml
<Project>
  <Target Name="Build">
    <MSBuild Projects="$(projects)" />
  </Target>
</Project>
```

---

## 🎉 **Enjoy Faster Builds!**  
If your deployment method allows copying only changed files/projects, this script will save you time and resources.  
**Don't build the whole solution—build only what has changed!**  

---
