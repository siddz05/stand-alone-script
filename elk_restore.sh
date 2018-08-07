#This, script is not tested please use -- restore_elk.py with anaconda3

echo "Welcome, To The Restore ELK Process!!"
# Variables
curDateTime=`date +"%y-%m-%d-%H-%M"`
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "--------- Restore ELK Process Started ---- $curDateTime"
echo "======================================================="
echo 
dumpName=$1
homeDir="/home/ubuntu/"
bucketName="walmart-stream-storage-beta"
bucketAbsPath = "/walmart-stream-storage-beta/elk-logs/"
localPath = "elk-backup/"
absLocalPath=$homeDir+$localPath
elkLocation = "/var/lib/elasticsearch"
elk="elasticsearch"

#Check branch Name
if [ -z "$dumpName" ];
  then 
      echo "Config not specified!!"
      echo "Pls use syntax : sh elk_restore.sh <file_name.tar.gz>"
      exit 1

cd ~
sudo gsutil cp gs://$bucketName+$bucketAbsPath+$dumpName $absLocalPath$dumpName &&
cd $absLocalPath
sudo tar -xvzf $dumpName &&
sudo mv $elk /var/lib/elasticsearch &&
cd ~
sudo service elasticsearch restart

echo "~~~~~~ And We Are Ready To Go! ~~~~~~~~~ $config"                       
