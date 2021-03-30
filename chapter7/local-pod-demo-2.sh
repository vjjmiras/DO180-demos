# Auxiliary functions

function pause {
  echo; echo $@; echo;
  read -s -p "Press Enter to continue ... ";
  echo; 
}

function cleanup {
  echo "Stopping pod" && \
    sudo podman pod stop podinfo-pod
  echo "Deleting podinfo container" && \
    sudo podman rm podinfo
  echo "Deleting redis container" && \
    sudo podman rm redis
  echo "Deleting pod" && \
    sudo podman pod rm podinfo-pod
  unset cleanup
}

# Beginning of the demo

pause "Create the pod (with its infra container)"

sudo podman pod create --name podinfo-pod -p 8080:9898

pause "Add the database container (redis)"

sudo podman run -d --name redis \
  -e ALLOW_EMPTY_PASSWORD=true \
  --pod podinfo-pod docker.io/redis 

pause "Add the frontend container (podinfo)"

sudo podman run -d --name podinfo \
  --pod podinfo-pod docker.io/stefanprodan/podinfo:5.1.2 \
  ./podinfo --cache-server localhost:6379

pause "Pod ready to use. Run 'cleanup' when done"
