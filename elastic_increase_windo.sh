curl -XPOST 'http://localhost:9200/wmt-stream-prod-log/_close?pretty' &&
curl -XPUT 'localhost:9200/wmt-stream-prod-log/_settings?pretty' -d '{"template":"*","order":0,"settings":{"max_result_window":20000000}}' &&
curl -XPOST 'http://localhost:9200/wmt-stream-prod-log/_open?pretty' &&
sudo service elasticsearch restart
