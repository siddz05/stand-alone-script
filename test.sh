#!/bin/bash
echo "Before Sleep!@"
t1=`date +%s`
echo $t1
sleep 1
t2=`date +%s`
diff=`expr $t2 - $t1`
echo "After 10 Sc Sleep!! "$t2
echo "diff -- "$diff

echo "Going sudo su"
sudo su
cd /var/lib/
echo "create dir"
sudo rm -rf siddd
sudo mkdir siddd
#-- Change Permission --
sudo chown -R sid:sid siddd
exit
echo "Outside sudo su"
pwd
