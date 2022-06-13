#!/usr/bin/env bash
#
# =======================================
# AUTHOR        : Claudio Prato @Team EA
# CREATE DATE   : 2022/06/13
# PURPOSE       : Setting a default Kibana index pattern
# SPECIAL NOTES :
# =======================================
#
# From https://github.com/elastic/kibana/issues/3709
# 
# Tested on Kibana 6.8.1 management
# 
set -euo pipefail
url="http://localhost:5601"
index_pattern="app-*"
id="app-*"
time_field="@timestamp"

# curl -XGET "https://elasticsearch.openshift-logging.svc:9200/_cat/indices?v"


# ::: 1 - create index da openshift
#   POST https://kibana-openshift-logging.apps.sno-cluster.okd-sno.dedalus.red.com/api/saved_objects/index-pattern/default-app-index {"attributes":{"title":"app-*","timeFieldName":"@timestamp"}}
curl -lk -XPOST "https://kibana-openshift-logging.apps.sno-cluster.okd-sno.dedalus.red.com/api/saved_objects/index-pattern/default-app-index?overwrite=true" \
  -H "Cookie: security_preferences=6qui3AGZUsecPwklAo-CUH9pxC4dL0nZufMaoYnw; security_storage=kewKg0uRvDyMMC3PXgD0W6MVvAym4jMaCxguMf1zPCk; fd68dcec74cd05890f5599932b99c660=f42e8c6e0a3860b5acd3da5905c6ead4; _oauth_proxy=aHmGGDBkjQ=" \
  -H 'Content-Type: application/json' \
  -H "kbn-xsrf: kibana-setup" \
  -d'
{
    "attributes": {
        "title": "app-*",
        "timeFieldName": "@timestamp" 
    }
}'

# ::: 2 - set default index pattern
# POST https://kibana-openshift-logging.apps.sno-cluster.okd-sno.dedalus.red.com/api/kibana/settings {"changes":{"defaultIndex":"default-app-index"}}
curl -lk -XPOST "https://kibana-openshift-logging.apps.sno-cluster.okd-sno.dedalus.red.com/api/kibana/settings" \
  -H "Cookie: security_preferences=_6qui3AGZUsecPwklAo-CUH9pxC4dL0nZufMaoYnw; security_storage=kewKg0uRvDyMMC3PXgD0W6MVvAym4jMaCxguMf1zPCk; fd68dcec74cd05890f5599932b99c660=f42e8c6e0a3860b5acd3da5905c6ead4; _oauth_proxy=1652972024|HktiuCtx3jV5VtnXDaHmGGDBkjQ=" \
  -H 'Content-Type: application/json' \
  -H "kbn-xsrf: test" \
  -d'
{
    "changes": {
        "defaultIndex": "default-app-index"
    }
}'

# ::: 3 - search for structured fields by browser with active session
# 
# see the template: deploy/templates/kibana-externallink.template.yml