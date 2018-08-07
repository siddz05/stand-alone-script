#!/bin/bash
cd ~  &&
# -- step 1 Stoping All Services logstash / elasticsearch / kibana / nginx --
echo "Stoping All Services..."
sudo service logstash stop &&
service=logstash
count=$(ps -ef | grep -v grep | grep $service | wc -l)
while :
do
count=$(ps -ef | grep -v grep | grep $service | wc -l)
echo $count
if [ $count -gt 0 ]
then
echo "$service is running!!!"$count
sudo service $service stop
else
echo "$service is Not running!!!"$count
break;
fi
done
sudo service elasticsearch stop  &&
sudo service kibana  stop  &&
sudo service nginx stop  &&
cd ~  &&
# -- step 2 Copy The Elasticsearch Dump to /home/ubuntu/ --
sudo mv /var/lib/elasticsearch . &&
#-- Step TO Create Elasticsearch Dir --
cd /var/lib/ &&
sudo -u root mkdir elasticsearch/ &&
sudo -u root chown -R elasticsearch:elasticsearch elasticsearch/ &&
cd ~ &&
# -- step 3 Restarting All Services logstash / elasticsearch / kibana / nginx -- 
echo "Restarting All Services..." 
sudo service logstash restart  &&
sudo service elasticsearch restart  &&
sudo service kibana restart  &&
sudo service nginx restart  &&
# -- step 3 Compressing The Elasticsearch Dump into a tar.gz File --
now=$(date +"%m_%d_%Y") 
fileName="elasticsearch_logs_"$now".tar.gz"  &&
echo "compressing for elasticsearch"
sudo tar -zcvf $fileName elasticsearch/ &&
echo "Copy File To GCP Bucket.."
# -- step 4 Pushing The Compressed Version to GCP Bucket -- gs://walmart-stream-storage-beta/elk-logs/ --
sudo gsutil -m cp -r $fileName gs://walmart-stream-storage-beta/elk-logs/ &&
echo "Removing ALl the Temp elasticearch folder and tar file.."
cd ~
# -- step 6 Removing The elasticsearch dump and the tar.gz files -- 
sudo rm -rf elasticsearch $fileName


