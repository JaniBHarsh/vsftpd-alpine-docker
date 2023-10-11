aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 561872739683.dkr.ecr.us-east-2.amazonaws.com 

docker pull 561872739683.dkr.ecr.us-east-2.amazonaws.com/vsftpd

docker tag  561872739683.dkr.ecr.us-east-2.amazonaws.com/vsftpd vsftpd 

docker-compose -f ~/vsftpd-alpine-docker/docker-compose.yml down 

docker-compose -f ~/vsftpd-alpine-docker/docker-compose.yml up -d