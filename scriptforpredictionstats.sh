if [ $# -ne 2 ]
then
  echo "use : ./scriptforpredictionstats.sh [system-ip] [total_rows]"
  exit 1
fi
echo $2
a=$2
if [ "$a" -ne "500" ] || [ "$a" -ne "1L" ];
then
  echo "To"
  exit 1
fi
if [ $# -eq 2 ]
then 
     echo "===========Script for getting PredictionStats=============" 
     echo "=========================================================="
     echo	
     for i in $(cat models-for-predictionstats.txt);
       do
         echo
         echo "Triggered the $i model"
         echo
         curl -X POST http://$1/api/status/getpredictionstats -H 'cache-control: no-cache' -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' -H 'postman-token: a7d17722-201a-9fae-a418-c08e67e3d717' -F modelName=$i -F count=$2
         echo
         echo
       done >> output-file.txt
     echo "=======Triggered Prediction Stats for All the Models=======" 
     echo "==========================================================="
fi 
