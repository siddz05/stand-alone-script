echo "Deleting The Atto Folder" &&
sudo rm -rf /home/ubuntu/Atto-master &&
cd /home/ubuntu/pl_models_repo &&
sudo rm -rf /home/ubuntu/pl_models_repo/* &&
echo "Cloning walmart-stream code For Perl." &&
git clone git@git.crowdanalytix.com:retail-stream/walmart-stream.git &&
echo "Clone Completed, Moving The Atto Foler To Home." 
cd ~ &&
sudo cp -R /home/ubuntu/pl_models_repo/walmart-stream/perl_microservice/Atto-master /home/ubuntu/ &&
echo "Changing Permison to ubuntu:ubuntu"
sudo chown -R ubuntu:ubuntu Atto-master
echo "Restartng SuperVisor..."
sudo service supervisor restart
echo "We Are Good To Go!"
