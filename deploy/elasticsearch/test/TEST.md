# Setup the testing environment

References:
* https://docs.okd.io/4.9/logging/cluster-logging-deploying.html
* https://access.redhat.com/documentation/en-us/openshift_cluster_manager/2022/html/managing_clusters/assembly-managing-clusters#downloading_and_updating_pull_secrets
* https://docs.okd.io/4.10/post_installation_configuration/preparing-for-users.html#olm-installing-operators-from-operatorhub-configure_post-install-preparing-for-users

## Pre-Requisites

Before proceed in logging components setup, it is needed as follow if you have the okd cluster version

### AWS testing

role: cprato-test

Created by CreateImage(i-0fa2bbdc8f90ebc28) = sno-r4c-cluster-f5ndt-master-0

Volume:
  KMS Key ID = 84efaa89-e430-47f5-8031-944799538257
  availability zone = eu-central-1b

* vol-0511a969cc2491b1e	/dev/xvda	120
* vol-0a4bd5223ce2ce8b6	/dev/xvdbf	5
* vol-02b47bda2ebeaef51	/dev/xvdbq	10
* vol-0026f70ea9dd7fd26	/dev/xvdct	47

The new ones (TAG: role=cprato-test):

* snap-07af8842b6d2119cd	120 GiB /dev/xvda  [io1 = 4000]
  =>  vol-078b261f272ffa2ac
* snap-0290b007ec66bb238	10 GiB /dev/xvdbq (da incrementare a 10Gb) [gp2 = 100]
  =>  vol-0fac387f50483b41c
* snap-0dad1d77260399d61	5 GiB /dev/xvdbf [gp2 = 100]
  =>  vol-0ffca5f09e51e0c15
* snap-09c90dcd9f6e56655	47 GiB /dev/xvdct (auto attached) [gp2 = 100]


#### AWS Volume Switch

```bash
    python volume-attacher.py \
        --access_key AKIAIVKXXXXXXXG3N32Q \
        --secret_key UGSYQL6XXXXXXXXXXXX0bS/S+OwnA2GrJ0MOY4Y \
        --volume vol-dxx2129c \
        --instance i-16xx3f38 \
        --device /dev/sdb \
        --force \
        switch
```


### Getting the default pull secret

```bash
oc get secret/pull-secret -n openshift-config --template='{{index .data ".dockerconfigjson" | base64decode}}' > default-pull-secret.yml
```

### Setting the default pull secret

```bash
oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=pull-secret.yml
```

###

Edit the operator cluster object:

```bash
oc edit OperatorHub cluster
```

and add the redhat-operators entry as shown below:

```yaml
apiVersion: config.openshift.io/v1
kind: OperatorHub
metadata:
  name: cluster
spec:
  disableAllDefaultSources: true
  sources:
  - disabled: false 
    name: redhat-operators
  - disabled: false
    name: community-operators
```