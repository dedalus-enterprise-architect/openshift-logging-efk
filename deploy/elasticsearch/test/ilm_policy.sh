oc exec -n openshift-logging -c elasticsearch ${es_pod} -- es_util --query=ilm/policy/ilm_dedalus_policy -XPUT -d'
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_size": "5MB" 
          }
        }
      },
      "delete": {
        "min_age": "30d",
        "actions": {
          "delete": {} 
        }
      }
    }
  }
}'