/usr/bin/openssl rand -base64 741 > mongo-keyfile
kubectl create secret generic mongo-keyfile --from-file=mongo-keyfile
rm mongo-keyfile
