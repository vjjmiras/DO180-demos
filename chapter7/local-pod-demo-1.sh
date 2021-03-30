# Auxiliary functions

function pause {
  echo; echo $@; echo;
  read -s -p "Press Enter to continue ... ";
  echo; 
}

function cleanup {
  echo "Stopping pod" && \
    sudo podman pod stop blog-pod
  echo "Deleting wordpress container" && \
    sudo podman rm wordpress
  echo "Deleting mariadb container" && \
    sudo podman rm mariadb
  echo "Deleting pod" && \
    sudo podman pod rm blog-pod
  unset cleanup
}

# Beginning of the demo

pause "Create the pod (with its infra container)"

sudo podman pod create --name blog-pod -p 8080:80

pause "Add the database container (mariadb)"

sudo podman run -d --name mariadb \
  -e MYSQL_ROOT_PASSWORD=RedHat123@! \
  -e MYSQL_USER=wordpress \
  -e MYSQL_PASSWORD=password \
  -e MYSQL_DATABASE=wordpress \
  --pod blog-pod docker.io/mariadb 

pause "Add the frontend container (wordpress)"

sudo podman run -d --name wordpress \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=password \
  -e WORDPRESS_DB_HOST=127.0.0.1 \
  -e WORDPRESS_DB_NAME=wordpress \
  -e WORDPRESS_DB_TABLE_PREFIX=wordpress \
  --pod blog-pod docker.io/wordpress 

pause "Pod ready to use. Run 'cleanup' when done"
