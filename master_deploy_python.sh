#-- Script TO DO STARTS--
#Copy the present deployed code to a folder (with timmestap)
#Delete the deployed folder
#clone the GIT
#Copy the file inside /walmart-stream/config
#change permission to ubuntu:ubuntu
#stop supervisor
#kill ports on 8080
#restart supervisor 
#-- Script TO DO ENDS--
echo "Welcome, To The Git Clone Master Script. -- Deployment Process!!"
# Variables
curDateTime=`date +"%y-%m-%d-%H-%M"`
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "--------- Deployment Process Started ---- $curDateTime"
echo "======================================================="
echo 
cloneDir="/home/ubuntu/wmt-stream-python-source/"
configDir="/walmart-stream-python/config/"
buildDir="/home/ubuntu/wmt-stream-python-source/walmart-stream-python"
basebackupDir="/home/ubuntu/wmt-stream-python-source-backup"
config=$1
user="ubuntu"
echo "Processing For -- "$config
#Step 0 -- PreDeployment Checks
#empty config Check
if [ -z "$config" ];
  then 
      echo "Config not specified!!"
      echo "Pls use syntax : sh master_deploye.sh beta/stag/prod-light/prod-heavy"
      exit 1
fi
#check, correct config
if [ "$config" = "beta" ] || [ "$config" = "stag" ] || [ "$config" = "prod-light" ] || [ "$config" = "prod-heavy" ];
then
   echo "Config Is Correct --master_deploye.sh $config"
else
   echo "Please, use sh master_deploye.sh beta || sh master_deploye.sh stag || sh master_deploye.sh prod-light || sh master_deploye.sh prod-heavy"
   exit 1
fi
cd ~
#step 1 -- Backup Process
echo "Step 1 -- Backup Process --"
backupDir=$basebackupDir/$curDateTime
echo "-- Creating Backup Folder $backupDir --"
sudo mkdir -p $backupDir
echo "-- Copying Backup Folder to $backupDir--"
sudo cp -R $buildDir $backupDir/
#step 2 -- removing the present deployment
echo "Step 2 -- removing the present deployment Dir--"
sudo rm -rf $buildDir
#Step 3 -- Clone The Latest Build in $cloneDir
echo "Step 3 -- Clone The Latest Build in $cloneDir--"
cd $cloneDir
echo "Cloning the master repo, $cloneDir"
#git pull origin master
git clone git@git.crowdanalytix.com:retail-stream/walmart-stream-python.git
#Step 4 -- Copy the Config to $configDir
echo "-- Step 4 Copy the Config to $configDir --"
cd ~
echo "Clearing The Config File Dir"
sudo rm -rf $configDir*
sudo cp /home/ubuntu/wmt-stream-python-source/walmart-stream-python/python_common/config/$config/*.py $configDir
#step 5 -- Change Permission of $configDir
echo "-- Step 5 -- Change Permission of $configDir --"
sudo chown -R $user:$user $configDir
#step 6 -- Checkout py_branch from master 
echo " -- Checkout py_branch from master --"
cd $cloneDir"walmart-stream-python/"
git checkout -b py_branch
#Step 7 -- Stoping The Supervisor, Killing Ports and Restarting the Server!!
echo "-- Step 6 -- Stoping The Supervisor, Killing Ports and Restarting the Server!! --"
echo "Stoping Supervisor..."
sudo service supervisor stop
echo "Killing All Ports. 8080/tcp"
sudo fuser -k 8080/tcp
echo "Restarting Supervisor.."
sudo service supervisor start
echo "~~~~~~ And We Are Ready To Go! ~~~~~~~~~ $config"                       
