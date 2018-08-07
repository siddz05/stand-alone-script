#1 Clone The Git
#2 Checkout To Brnach 
#3 Pull The Code From Master
#4 Push it to your brnahc

git clone git@git.crowdanalytix.com:retail-stream/walmart-stream.git &&
cd walmart-stream/ &&
git checkout -b beta &&
git pull origin master &&
git push origin beta &&
git checkout -b stag &&
git pull origin master &&
git push origin stag