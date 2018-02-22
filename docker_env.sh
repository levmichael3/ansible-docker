
docker-machine start aws-sandbox
sleep 2
docker-machine regenerate-certs aws-sandbox
sleep 2
eval "$(docker-machine env aws-sandbox)"
docker-machine status aws-sandbox

