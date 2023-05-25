
# kubectl create secret docker-registry docker-secret --docker-server=https://index.docker.io/v1/ --docker-username=guptaashwanee --docker-password=Ashwanee@123456 --docker-email=ashwanee2001gupta@gmail.com
kubectl create secret tls tls-secret --cert=tls.crt --key=tls.key
kubectl apply -f .