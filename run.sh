#!bin/sh

# Apply all K8s manifests setting up storage/pv's/statefulset.
echo "Applying all Kubernetes manifests"
kubectl apply -f 0-general/
kubectl apply -f 01-storage/
kubectl apply -f 02-mongo/

# Wait for the mongo instances to run.
echo "Waiting for the mongo containers to run (`date`)."
sleep 30
echo -n "  "
until kubectl -n ghtorrent --v=0 exec mongo-2 -c mongod-container -- mongo --quiet --eval 'db.getMongo()'; do
    sleep 5
    echo -n "  "
done

echo "Mongo containers are now running (`date`)."
