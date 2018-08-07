echo "Deployment Script -- Fro walmart Utility App"
cd ~
sudo fuser -k 8080/tcp
cd /home/ubuntu/walmart-utility-app/
git pull origin master
cd ~
