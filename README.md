# 🍃 MongoDB manifests for Kubernetes

This repository stores manifests to run a 3-node replicated MongoDB
cluster on Kubernetes.

## Prerequisites
- Kubernetes cluster with at least 3 worker nodes.
- Each node has a [ZFS
dataset](https://www.thegeekdiary.com/zfs-tutorials-creating-zfs-pools-and-file-systems/) mounted on `/mnt/mongo`.
- The nodes are named: `node_one`, `node_two`, `node_three`. To change
this in the manifests see the [pv-mongo
file](01-storage/01-pv-mongo.yaml).

## How To Run
```sh
git clone https://github.com/codefeedr/mongo-kubernetes
./run.sh
```

## Architecture
![](arch.png)
The mongo instances are deployed on the three worker nodes behind a
(headless) service. The (internal) addresses of these instances:

```bash
mongo-0.mongo-hs.ghtorrent:27017
mongo-1.mongo-hs.ghtorrent:27017
mongo-2.mongo-hs.ghtorrent:27017
```

The login credentials:  
**username:** ghtorrent  
**password:** ghtorrent

---
### Resources

1.[https://pauldone.blogspot.com/2017/06/deploying-mongodb-on-kubernetes-gke25.html](https://pauldone.blogspot.com/2017/06/deploying-mongodb-on-kubernetes-gke25.html)  
2.[https://stackoverflow.com/questions/51815216/authentication-mongo-deployed-on-kubernetes](https://stackoverflow.com/questions/51815216/authentication-mongo-deployed-on-kubernetes)  
3.[https://github.com/pkdone/gke-mongodb-demo](https://github.com/pkdone/gke-mongodb-demo)    
