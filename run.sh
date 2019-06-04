#!bin/sh

# Apply all K8s manifests setting up storage/pv's/statefulset.
echo "Applying general Kubernetes manifests."
kubectl apply -f 0-general/
echo

echo "Creating keyfile for MongoDB secret."
TMPFILE=$(mktemp)
/usr/bin/openssl rand -base64 741 > $TMPFILE
kubectl -n ghtorrent create secret generic shared-bootstrap-data --from-file=internal-auth-mongodb-keyfile=$TMPFILE
rm $TMPFILE

echo "Applying MongoDB manifests."
kubectl apply -f 01-storage/
kubectl apply -f 02-mongo/
echo

# Wait for the mongo instances to run.
echo "Waiting for the mongo containers to run (`date`)."
sleep 30
echo -n "  "
until kubectl -n ghtorrent --v=0 exec mongo-2 -c mongod-container -- mongo --quiet --eval 'db.getMongo()'; do
    sleep 5
    echo -n "  "
done

echo "Mongo containers are now running (`date`)."

# Initiate MongoDB Replica Set configuration
echo "Configuring the MongoDB Replica Set"
kubectl -n ghtorrent exec mongo-0 -c mongod-container -- mongo --eval 'rs.initiate({_id: "MainRepSet", version: 1, members: [ {_id: 0, host: "mongo-0.mongo-hs.ghtorrent.svc.cluster.local:27017"}, {_id: 1, host: "mongo-1.mongo-hs.ghtorrent.svc.cluster.local:27017"}, {_id: 2, host: "mongo-2.mongo-hs.ghtorrent.svc.cluster.local:27017"} ]});'
echo

# Wait for the MongoDB Replica Set to have a primary ready
echo "Waiting for the MongoDB Replica Set to initialise..."
kubectl -n ghtorrent exec mongo-0 -c mongod-container -- mongo --eval 'while (rs.status().hasOwnProperty("myState") && rs.status().myState != 1) { print("."); sleep(1000); };'
#sleep 2 # Just a little more sleep to ensure everything is ready!
sleep 20 # More sleep to ensure everything is ready! (3.6.0 workaround for https://jira.mongodb.org/browse/SERVER-31916 )
echo "...initialisation of MongoDB Replica Set completed"
echo

# Create the admin user (this will automatically disable the localhost exception)
echo "Creating user: 'main_admin'"
kubectl exec mongod-0 -c mongod-container -- mongo --eval 'db.getSiblingDB("admin").createUser({user:"ghtorrent",pwd:"ghtorrent",roles:[{role:"root",db:"admin"}]});'
echo
