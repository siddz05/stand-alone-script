#!/bin/bash
echo "Welcome, To The Gatling Load Testing Tool Automation Script !!"
curDateTime=`date +"%y-%m-%d-%H-%M"`
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "---------Gatling Load Testing Automation Script Started ---- $curDateTime"
echo "======================================================="
echo
#-- Step 0 Define All Variables As Needed --
#Variables -- System URL -- input JSON File Name -- model names comma seperated -- apikey -- jsonFilePath -- api URL -- duration to run the test -- outputFolder Prefix -- scala File Name 
baseUrl=$1 #https://beta2-wmt.crowdanalytix.com 
inputFileName=$2 #1_group.json
models=$3 #age_group
apiKey=$4 #k9b4pi42-58lk-gtg8-dn45-bnvgt4j8fd55
inputfilePath=$5 #/home/ubuntu/gatling-charts-highcharts-bundle-2.3.1/user-files/data/
api=$6 #/api/process/predictions
duration=$7 #1 (in miniutes)
outputFolder=$8 #wmtLoadTest-<TimeStamp>
outputDesc=$9 #wmtLoadTestDesc
scalaFile=$10 #The Scala File You want To Run, in the simulation (Required Param)
constantUsers=$11
gatlingLogDir=$12 #"/walmart-stream-resources/logs/gatlingRunTimeLog.log"
gatlingBaseDir=$13 #"/home/sid/Downloads/gatling-charts-highcharts-bundle-2.3.1/bin/"
echo $scalaFile
#Check If All The Required Params
if [ -z "$scalaFile" ];
  then 
      echo "scalaFile not specified!!"
      echo "Pls use syntax : sh gatling_automation.sh https://beta2-wmt.crowdanalytix.com 1_group.json amps k9b4pi42-58lk-gtg8-dn45-bnvgt4j8fd55 /home/ubuntu/gatling-charts-highcharts-bundle-2.3.1/user-files/data/ /api/process/predictions 2 wmtLoadTest wmtLoadTestDesc ae2.GatlingLoadTest2"
      exit 1
fi
cd ~
# -- Step 1 Trigger Script -- 
JAVA_OPTS="-DbaseUrl=$baseUrl -DinputData=$inputFileName -Dmodels=$models -DapiKey=$apiKey -Dapi=$api -DfilePath=$inputfilePath -Dgatling.core.outputDirectoryBaseName=$outputFolder -Dduration=$duration -Dusers=$constantUsers" sh "$gatlingBaseDir"gatling.sh -s $scalaFile -rd $outputDesc > $gatlingLogDir

