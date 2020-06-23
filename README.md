# Poppin

Repository for Poppin (iOS)

# Installation:

In order to install Poppin and open it in XCode follow these instructions (assuming your git account is already logged in  XCode):

  1. Open XCode and clone this repository somewhere in your computer.
  
  2. Once cloned, open the repository folder and check that all the files are present.
  
  3. Open Terminal and cd to the "Poppin" folder inside the repository directory.
  
  4. Run "pod install"
  
  5. Once it has finished, run "pod update"
  
  6. Once it has finished, run "pod outdated". It will show any remaining outdated pods. If there are some, then repeat 5.
  
  7. Open the "Poppin.xcworkspace" file (NOT THE "Poppin.xcodeproj" ONE).
  
  8. Once XCode has launched, press CMD+B. This will build the newly created project.
  
  9. Once it has finished building, make sure there are no RED alerts on your project. If there are, then close XCode, repeat step 3, run "pod deintegrate", once finished repeat steps 4, 5, 6, 7, and 8.
  
  10. Open XCode preferences and click on the "Source Control" tab. Then, click in the "git" tab underneath. On the "Ignored Files" box, add every line inside the .gitignore file (except for comments). This will ensure that XCode ignores irrelevant files.
  
# Solving Pods Merge Conflicts:

Simply pick the side that has the pods (and versions) that you want to keep. 

Then, choose that side for all the conflicts in both the "Podfile" and "Podfile.lock". 

Once all conflicts have been solved, close XCode, and perform steps 3, and 4 from the installation process (ONLY). Then, open XCode and build the project.

# Solving Project.pbxproj Merge Conflicts:

First of all, in order to avoid this kind of conflict, please read "IMPORTANT NOTES - 2.". 

Despite our best efforts, this kind of conflict is very likely to happen. Thus, in order to solve it, there is a .gitattributes file in the repository directory containing instructions on how git should handle it automatically (by doing a union of both files). 

However, the conflict might lead to the "Project.pbxproj" file being corrupted (due mostly to missing commas and duplicated statements). In that case, follow this tutorial to fix the file: https://medium.com/@avendi.sianipar/alternative-way-to-solved-conflict-project-pbxproj-in-xcode-using-kin-d4684aedd2fb

Alternatively if the tutorial does not work, you can use reset the branch (remove all files in the branch and commit) and then use the brute force approach.

# Brute Force Approach for Solving Merge Conflicts (NOT RECOMMENDED):

  1. Make a new branch from one of the working branches (Ex: A -> B & A -> C is the current branch hierarchy. Then, branch out of B or C).
  
  2. Copy the files from the other working branch that you want to merge and save them somewhere in your computer.
  
  3. Manually copy and past those files as needed into the newly created branch.
  
  4. Once the branch is working properly, merge the newly created branch into its parent branch (Now, A -> BC).
  
  5. Finally, merge the combined branch into the head branch.

# IMPORTANT NOTES:

  1. When switching branches, always make sure to refresh and fetch status, pull any changes, and run "pod install" if any pods are missing. Then, you should be able to edit the branch safely.
  
  2. When moving files around or creating folders, try to commit the changes ASAP (even if the commit is to simply notify you added a folder). This will ensure that the "project.pbxproj" file does not get too crazy, and avoids future merge conflicts.
  
  3. Do not delete a branch until it has been successfully merged with the head branch and other members of the repository can confirm so.

# Implemented features:

  - Map View.
  
  - Create Event View.
  
  - Login/Register View.
  
  - Profile View.
  
  - Popsicle View.
  
  - Online Database.
  
# Features to implement:

  - Menu View.
  
  - Settings/Terms&Privacy View.
  
  - Security.
  
  - Testing.
  
  - Admin Rights.
  
  - Tutorial View.
  
# Future features:

  - Automation of the event creation process.
