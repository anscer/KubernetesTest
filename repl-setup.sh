#!/bin/bash

initiated=0
replica_exists=false
while [ "$replica_exists" != true ]
do
    # Need to check to make sure that the other pods are currently up
    initiated=`mongosh --host mongo-0.mongodb-service --quiet --eval 'rs.initiate({_id: "anya-rs", version: 1, members: [{ _id: 0, host : "mongo-0.mongodb-service:27017" },{ _id: 1, host : "mongo-1.mongodb-service:27017" },{ _id: 2, host : "mongo-2.mongodb-service:27017" }]})["ok"]'`;
    replica_exists=`mongosh --host mongo-0.mongodb-service --quiet --eval 'db.isMaster()["ismaster"]'`;
    # Shit we need to check rs status i think instead
    echo "Replica exists: " $replica_exists;
    sleep 2
done
# If everything else is workign then we need to create an admin user
mongosh --host ${MONGODB0} <<EOF
    use admin;
    admin = db.getSiblingDB("admin");
    admin.createUser(
    {
    user: "${MONGODB_USER}",
        pwd: "${MONGODB_PASSWORD}",
        roles: [ { role: "root", db: "admin" } ]
    });
    use ${MONGODB_DATABASE};
    db.users.insertOne({ "name": "${MONGODB_ADMIN_USER}", "password": "${MONGODB_ADMIN_PASSWORD}", "email": "${MONGODB_ADMIN_EMAIL}", "role": "${MONGODB_ADMIN_ROLE}" });
EOF

# kubectl create configmap repl-config --from-file=./repl-setup.sh
