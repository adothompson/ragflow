#!/bin/bash

# replace env variables in the service_conf.yaml file
rm -rf /ragflow/conf/service_conf.yaml
while IFS= read -r line || [[ -n "$line" ]]; do
    # Use eval to interpret the variable with default values
    eval "echo \"$line\"" >> /ragflow/conf/service_conf.yaml
done < /ragflow/conf/service_conf.yaml.template

echo "Waiting for Elasticsearch..."
ES_READY=0
for i in {1..15}; do
  if curl -sSf http://elasticsearch:9200/_cluster/health | grep -q '"status":"green"'; then
    ES_READY=1
    break
  fi
  echo "Elasticsearch not ready - retrying in 15s (attempt $i/15)..."
  sleep 15
done

if [ "$ES_READY" -ne 1 ]; then
  echo "FATAL: Elasticsearch health check failed after 15 attempts"
  exit 1
fi

/usr/sbin/nginx

# Storage handled via mounted disk

PY=python3
if [[ -z "$WS" || $WS -lt 1 ]]; then
  WS=1
fi

function task_exe(){
    while [ 1 -eq 1 ];do
      $PY rag/svr/task_executor.py $1;
    done
}

for ((i=0;i<WS;i++))
do
  task_exe  $i &
done

exec $PY api/ragflow_server.py

wait;
