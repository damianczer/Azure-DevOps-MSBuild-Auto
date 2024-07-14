Do you have a **BIG** solution? <br />
More than **100** projects? <br />
Don't you use **Docker Containers** and have to build the whole solution? <br />
Does it take a lot of time to build the entire solution through **Pipeline Azure DevOps**? <br />
Are you waiting more than **20 minutes** even the changes were minimal? <br />

Here is the Solution! <br />

Before:

![image](https://github.com/user-attachments/assets/8f72e8f9-7fcf-4d71-9df4-f183edb814d9)

After:

![image](https://github.com/user-attachments/assets/5e4e6e01-9a2e-46bd-8d34-cfdec00700ec)

Step Configuration:

![image](https://github.com/user-attachments/assets/446de0d0-5a15-41ef-8f04-c93038bb91e4)

Pipeline Variables:

![image](https://github.com/user-attachments/assets/2106bb8b-8bea-4547-80a3-7f95292a5488)

MSBuild Configuration:

![image](https://github.com/user-attachments/assets/b4f653cf-312c-47dd-8bce-5c26afea8ac4)

Call **MSBuild** inside **Build.proj** with our global variable (list of changed projects) instead of Solution File (.sln):

![image](https://github.com/user-attachments/assets/72fd32b6-4f1c-41cb-b460-f48729d5b1bf)

If your deployment method allows you to _"copy only changed files/projects/.dlls"_ -> **let's do it!** Don't build the whole soloution, build what has changed! If the projects are dependent on each other - references will be built! This is just a proposal for a solution/optimization of software delivery to the client server.


