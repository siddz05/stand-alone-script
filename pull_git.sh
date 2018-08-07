echo "Welcome, To The Git Pull From Master Script."
# sudo service supervisor stop
cd ~
cd wmt-stream-source/walmart-stream/
echo "Pulling the master,  now git pull origin master"
git pull origin master
cd ~
echo "Stoping Supervisor..."
sudo service supervisor stop
echo "Killing All Ports. 8080/tcp"
sudo fuser -k 8080/tcp
echo "Restarting Supervisor.."
sudo service supervisor start
echo "And We Are Ready To Go!"
