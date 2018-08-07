#!/bin/bash
#https://github.com/jacksegal/google-compute-snapshot/blob/master/gcloud-snapshot.sh
#sh gcp_automation.sh deployment-production-wmt-stream test-script 4 10
echo "Welcome, To The Google Cloud Automation Script !!"
curDateTime=`date +"%y-%m-%d-%H-%M"`
#curDateTime=`date +"%M-%H-%Y-%b-%d"`
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "--------- Google Cloud Automation Script Started ---- $curDateTime"
echo "======================================================="
echo
#Step 0 -- Variables
baseVmName=$1
baseName=$2
cpu=$3
ram=$(expr $4 \* 1024)
projectName="wmt-stream-162506"
zoneName="us-central1-c"
size=$5
echo $size
family="wmt-stream"
network="projects/wmt-stream-162506/global/networks/wmt-stream"
serviceAccount="727815714891-compute@developer.gserviceaccount.com"
snapName="-snap-"
diskName="-disk-"
imageName="-image-"
instTemplateName="-template-"

#Create The SnapshotName / Disk
snapshotFullName=$baseName$snapName$curDateTime
diskFullName=$baseName$diskName$curDateTime
imageFullName=$baseName$imageName$curDateTime
instTemplateFullName=$baseName$instTemplateName$curDateTime

echo "======================================================="
echo "-- Step 1 Creating Snapshot  $snapshotFullName -- "
echo "======================================================="
echo
gcloud compute --project=$projectName disks snapshot $baseVmName --zone=$zoneName --snapshot-names=$snapshotFullName
echo "======================================================="
echo "-- Step 2 Creating Disks $diskFullName --"
echo "======================================================="
echo
sleep 15
gcloud compute --project=$projectName disks create $diskFullName --zone=$zoneName --type=pd-standard --source-snapshot=$snapshotFullName --size=$size
echo "======================================================="
echo "-- Step 3 Creating Image $imageFullName --"
echo "======================================================="
echo
sleep 15
gcloud compute --project=$projectName images create $imageFullName --family=$family --source-disk=$diskFullName --source-disk-zone=$zoneName
echo "======================================================="
echo "-- Step 4 Creting Template $instTemplateFullName --"
echo "======================================================="
echo
sleep 15
gcloud compute --project=$projectName instance-templates create $instTemplateFullName --machine-type=custom-$cpu-$ram --network=$network --maintenance-policy=MIGRATE --service-account=$serviceAccount --scopes=https://www.googleapis.com/auth/cloud-platform --min-cpu-platform=Automatic --tags=wmt-stream,http-server,https-server --image=$imageFullName --image-project=$projectName --boot-disk-size=$size --boot-disk-type=pd-standard --boot-disk-device-name=$instTemplateFullName
echo
echo "======================================================="
echo " -- We Are Ready To Roll -- Please, Verify The Template Manually Ones! -- "
echo "======================================================="
sleep 5
echo "Final Output {\"snapshotFullName\":\""$snapshotFullName"\", \"diskFullName\":\""$diskFullName"\", \"imageFullName\":\""$imageFullName"\", \"instTemplateFullName\":\""$instTemplateFullName"\"}"
