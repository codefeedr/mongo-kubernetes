# 🍃 MongoDB manifests for Kubernetes

This repository stores manifests to run a replicated MongoDB cluster on
Kubernetes.

## Prerequisites
- Kubernetes cluster with at least 3 worker nodes.
- Prometheus and Grafana running
- Each node has a [ZFS
dataset](https://www.thegeekdiary.com/zfs-tutorials-creating-zfs-pools-and-file-systems/) mounted on `/mnt/mongo`.
- The nodes are named: `node_one`, `node_two`, `node_three`. To change
this in the manifests see the [pv-mongo
file](01-storage/01-pv-mongo.yaml). 
