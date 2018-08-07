#Copy the present deployed code to a folder (with timmestap)
#Delete the deployed folder
#clone the GIT
#Copy the file inside /walmart-stream/config
#change permission to ubuntu:ubuntu
#stop supervisor
#kill ports on 8080
#restart supervisor 

echo "Welcome, To The Git Clone Master Script. -- Deployment Process!!"
# Variables
curDateTime=`date +"%y-%m-%d-%H-%M"`
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "--------- Deployment Process Started ---- $curDateTime"
echo "======================================================="
echo 
cloneDir="/home/ubuntu/wmt-stream-source/"
configDir="/walmart-stream/config/"
buildDir="/home/ubuntu/wmt-stream-source/walmart-stream"
basebackupDir="/home/ubuntu/wmt-stream-source-backup"
config=$1
branch_name=$2
user="ubuntu"
echo $config
#Step 0 -- PreDeployment Checks
echo $user
#Check branch Name
if [ -z "$branch_name" ];
  then 
      echo "Config not specified!!"
      echo "Pls use syntax : sh master_deploye.sh beta/prod/stag beta/stag/master"
      exit 1
fi
#empty config Check
if [ -z "$config" ];
  then 
      echo "Config not specified!!"
      echo "Pls use syntax :sh master_deploye.sh beta/prod/stag beta/stag/master"
      exit 1
fi
#check, correct config
if [ "$config" = "beta" ] || [ "$config" = "stag" ] || [ "$config" = "prod" ];
then
   echo "Config Is Correct --master_deploye.sh $config $branch_name"
else
   echo "Please, use sh master_deploye.sh beta beta || sh master_deploye.sh stag stag || sh master_deploye.sh prod master"
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
echo "Cloning the branch repo $branch_name, $cloneDir"
#git pull origin master
git clone -b $branch_name --single-branch git@git.crowdanalytix.com:retail-stream/walmart-stream.git
#Step 4 -- Copy the Config to $configDir
echo "-- Step 4 Copy the Config to $configDir --"
cd ~
echo "Clearing The Config File Dir"
sudo rm -rf $configDir*
sudo cp /home/ubuntu/wmt-stream-source/walmart-stream/stream_common/config/$config/*.py $configDir
#step 5 -- Change Permission of $configDir
echo "-- Step 5 -- Change Permission of $configDir --"
sudo chown -R $user:$user $configDir
#step 6 -- Checking Out Branch
echo " -- Checkout py_branch from master --"
cd $cloneDir"walmart-stream/"
git checkout -b stream
#Step 7 -- Stoping The Supervisor, Killing Ports and Restarting the Server!!
echo "-- Step 6 -- Stoping The Supervisor, Killing Ports and Restarting the Server!! --"
echo "Stoping Supervisor..."
sudo service supervisor stop
echo "Killing All Ports. 8080/tcp"
sudo fuser -k 8080/tcp
echo "Restarting Supervisor.."
sudo service supervisor start
echo "~~~~~~ And We Are Ready To Go! ~~~~~~~~~ $config"                       
