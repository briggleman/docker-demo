Docker Demo [![Build Status](https://travis-ci.org/briggleman/docker-demo.svg?branch=master)](https://travis-ci.org/briggleman/docker-demo)
===========

The purpose of this repository is to teach the basics of [Docker](https://www.docker.com/).  The different course topics, building and deploying, service discovery, and orchestration will be covered in different branches with the final project residing in **master**.

What is Docker?
--------------

Docker is a technology product, created by [Docker Inc.](https://www.docker.com/), based on the open-source [Moby project](https://mobyproject.org/). Docker is a tool to build and and run applications inside of containers based on Docker images, which is a portable and reusable file that launches an almost full-stack application environment.

Core Docker Concepts
--------------------
### Image
Images environment files are built from **Dockerfiles**. They are saved either locally or remotely via image registries, and are used to define the specification for containers. Containers are the running instance of any specific image.

Images compile and save a fully loadable environment for your code to run in, in a standardized way. 

[Learn more about Docker images](https://docs.docker.com/glossary/?term=image)

### Containers
Containers are the running environments instantiated from images. You can run containers in production or just locally.

Containers can be used for:
 - Production systems
 - Testing
 - CI/CD

[Learn more about Docker containers](https://docs.docker.com/glossary/?term=container)

### Volumes
Volumes are directories mounted either on the host machine or inside your containers (or both) that can share assets between containers. Volumes are a useful way to keep data separate from the container itself, so that it can store and persist outside the temporal nature of a container.

[Learn more about Docker volumes](https://docs.docker.com/glossary/?term=volume)

### Dockerfile
A **Dockerfile** is used to create a Docker Image.

Core Dockerfile Concepts:
 - FROM
   - Base Image to inherit from
 - EXPOSE
   -  Used to expose an application port to the Docker Daemon
 - ENV
   - Used to set environment variables
 - WORKDIR
   - Sets the working directory
 - COPY
   - Adds files, executables from a given path to the image
 - RUN
   - Executes shell commands
 - CMD
   - Provides defaults for executing a container
 - ENTRYPOINT
   - Allows you to configure a container that will run as an executable

### Docker Compose
Used to build and/or deploy multiple containers at once and written in YAML syntax.

Core Compose Concepts:
 - build
   - Builds a Docker Image from a Dockerfile
 - image
   - Name of image from Docker Hub or private Docker Trusted Registry (DTR)
 - environment
   - Environment variables
 - ports
   - Ports to expose
 - volumes
   - Volumes to mount

Getting Started
---------------

The best place to get started is with the [Docker hello-world tutorial](https://docs.docker.com/samples/library/hello-world/).  It covers the basics of installing Docker and running your first app.

Docker Demo Application
-----------------------
### Requirements
Docker is required to run this app.  Before running any commands [install Docker](https://docs.docker.com/engine/installation/) on your system.

### Building the application
The application can be built either using Docker or Docker Compose.  It is recommended that you try both since building with Docker will only build the *docker demo* application but building with Docker Compose will build the *docker demo* application and put it behind an nginx proxy, showcasing the ease of deploying with Docker.

#### Building with Docker
To build the application ensure docker is running the from your terminal and within the project directory execute the build command.

```bash
$ docker build -t docker-demo:1.0.0 .
``` 

This tells the docker engine to build the image based on *Dockerile* located in the root directory of the project.
Docker should begin to build our image from the *Dockerfile*.  If everything completed successfully you should see the following when you run the `docker images` command.

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker-demo         1.0.0               1a2ab7e6b098        3 seconds ago       335MB
python              3.6.2-slim          f39b8b8e7f07        12 days ago         206MB
```

One image, `python` is the image we built our image from and the other, `docker-demo` is the image we just built.  To run it use the following command.

```bash
$ docker run -td -p 8080:8080 --name docker-demo docker-demo:1.0.0
```

If everything worked you should see something similar when you check the running containers.

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
09406fc0e405        docker-demo:1.0.0   "python runserver...."   3 seconds ago       Up 2 seconds        0.0.0.0:8080->8080/tcp   docker-demo
```

You can check by going to [http://localhost:8080/v1](http://localhost:8080/v1).  If you see `{"data":"hello world!"}` then everything worked!

Let's stop that container and remove it so we can see how Docker Compose works.  To remove the container (non-gracefully) go:

```bash
$ docker rm -f $(docker ps -a -q)
```

Let's also remove the image.

```bash
$ docker rmi $(docker images -q)
```

You can check to see if everything was removed properly by checking your running containers and images like so.

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

There should be nothing listed under each.

#### Docker Compose
To build the image with Docker Compose is as simple as building with Docker.  Before we do that though let's change one small line in the **default.conf** file used by nginx.

Replace the `<YOUR IP HERE>` in the following line `proxy_pass http://<YOUR IP HERE>:8080;` with your IP.  e.g. `proxy_pass http://192.168.233.3:8080;`
Once that's done you can build the demo image and connect an nginx image by running Docker Compose like so.

```bash
$ docker-compose up -d
```

Docker/Docker Compose will know to build the image because of the compose file!  If you need to rebuild the image in the future you can append the `--build` flag and Docker will update the image.
If everything is running correctly you should see something similar when you run `docker ps`.

```bash
$ docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                  PORTS                    NAMES
6ca508f60331        nginx:1.13.5-alpine   "nginx -g 'daemon ..."   7 seconds ago       Up Less than a second   0.0.0.0:80->80/tcp       dockerdemo_nginx_1
63c00150797d        dockerdemo_demo       "python runserver...."   7 seconds ago       Up 5 seconds            0.0.0.0:8080->8080/tcp   dockerdemo_demo_1
```

To check if everything is working properly navigate to `http://<your ip>/v1`, e.g. `http://192.168.233.3/v1` if you see `{"data":"hello world!"}` then everything worked correctly!
If you don't check to make sure you replaced the IP with the proper IP of your machine.

Service Discovery
-----------------
Docker Service Discovery

What is Service Discovery?
--------------------------
Service Discovery is the automatic detection and registration of services available on a computer network.  Depending on the infrastructure, finding the components for a service can be simple, such as the case with static infrastructure with known IP's, or difficult, such as the case of dynamic infrastructure without static IP's.  

While most micro-services start as simple services, think web API with a database, they quickly grow to become complex as each piece scales at its own rate, think load balancer, web UI, web API and database.


Types of Service Discovery
--------------------------
There are two primary types of discovery patterns; client and server.

### Client Side Service Discovery
In a client side discovery pattern the client is aware of the service registry and directly queries it.  The service registry returns the route of an available resource for the client.

![client side service discovery][cssd]

### Server Side Discovery
In a server side discovery pattern the client makes a request to a load balancer which queries the service registry and returns the route to a resource.

![server side service discovery][sssd]

Docker Service Discovery
------------------------
### Server Side Service Discovery w/ Docker Compose (Simple)
In this example we will build and deploy our our web app with one small change; we will `link` the two containers using the `link` option.

When a container is linked to another container the linked container becomes available via its hostname to the linking container.

```yaml
version: "3"
services:
  # build our demo image from this directory using the Dockerfile
  demo:
    build: .
    restart: always
    ports:
      - "8080:8080"
  # pull and run nginx on port 80
  nginx:
    image: nginx:1.13.5-alpine
    restart: always
    # map the default.conf file located in this directory into the container
    # this will be used by nginx to proxy traffic into our demo container
    volumes:
      - ./simple.conf:/etc/nginx/conf.d/default.conf
    ports:
      - "80:80"
    # links `demo` to our `nginx` container
    links:
      - demo
```

In the above Docker Compose YAML file we `link` the service named `demo` to the service named `nginx`.  You can tell they are linked via the `links:` key.

We've also made a small change in our config file that gets mapped in to the Nginx container.  Specifically we set our IP to our demo containers hostname `demo`.

```text
# links demo container via its hostname `demo`
location / {
    proxy_pass http://demo:8080;
}
```

Let's bring up our new containers.  To do this we'll use the Docker Compose file named `simple.sd.dc.yaml`, we can tell Docker to use this file by passing the `-f` flag followed by the file name.

```bash
docker-compose -f simple.sd.dc.yaml up -d
Creating dockerdemo_demo_1 ...
Creating dockerdemo_demo_1 ... done
Creating dockerdemo_nginx_1 ...
Creating dockerdemo_nginx_1 ... done
```

You can check if everything is working properly by going to http://127.0.0.1/v1.  If everything is working properly you should see:

```json
{"data":"hello world!"}
```

Let's take a look at the logs.  We can do this by running the `docker logs` command.  You should see something similar to below.

```bash
$ docker logs -f dockerdemo_nginx_1
172.20.0.1 - - [17/Oct/2017:00:21:37 +0000] "GET /v1 HTTP/1.1" 200 23 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36" "-"
172.20.0.1 - - [17/Oct/2017:00:21:37 +0000] "GET /favicon.ico HTTP/1.1" 404 43 "http://127.0.0.1/v1" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36" "-"
```

The difference between this example and the one from the start of our Docker demo is that it is no longer routing requests from your computers IP, instead it's routing them via the containers network.  You  can tell this by the `172.20.0.1` address.

### Server Side Service Discovery w/ Ansible + Docker (Intermediate)
In this example we'll use [Ansible](https://www.ansible.com/) to deploy our services.  By using Ansible we will take advantage of its variable registration to register the IP of machine that we deploy the demo web app on so we can pass it to the Nginx container which will transform a template into a final config.  For this example you will need to install `Ansible`, you can do this using `pip`.

```bash
$ pip install ansible
$ pip install docker
```

Let's start by building our web app.  This will build our image and name if `docker-demo` and append the tag `ansible` to it.

```bash
$ docker build -t docker-demo:ansible .
```

Now let's run our playbook.

```bash
$ ansible-playbook ansible/site.yaml
```

If everything worked properly you should see something similar when running the command `docker ps`

```bash
$ docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                    NAMES
e54b68d6ec06        nginx:1.13.5          "/bin/bash -c 'env..."   3 minutes ago       Up 3 minutes        0.0.0.0:80->80/tcp       nginx
a253f9972ece        docker-demo:ansible   "python runserver...."   3 minutes ago       Up 3 minutes        0.0.0.0:8080->8080/tcp   docker_demo
```

You can also verify that everything worked properly by going to http://127.0.0.1/v1, you should see the following confirming everything worked properly.

```json
{"data":"hello world!"}
```

What Happened There?
--------------------
We used [Ansible](https://www.ansible.com/) to configure our deployment dynamically.  Ansible grabbed our `HOST IP` and set it as an envrionment variable in the Nginx container.  Ansible could have just as easily grabbed the `HOST IP` of the machine the web service was deployed to, registered it, and passed it into the Nginx container even if each service resided on a different VM.
Similarly, AWS tags can be used as a way of discovering services.

### Server Side Service Discovery Docker Compose + Consul (Advanced)
In this example we will use a key value store to dynamically register a service, see the service listed via Nginx and trace it back to Consul where it is registered.  We will also stop the service to see it get removed from Consul.

Let's bring up our new containers.  To do this we'll use the Docker Compose file named `simple.sd.dc.yaml`, we can tell Docker to use this file by passing the `-f` flag followed by the file name.

```bash
docker-compose -f advanced.sd.dc.yaml up -d
Creating demo ...
Creating consul ...
Creating consul
Creating consul ... done
Creating registrator ...
Creating demo ... done
Creating registrator
Creating nginx ... done
```

If everything worked you should be able to navigate to http://127.0.0.1 and see the following:

![nginx discovered services][nginxsd]

Click on `dockerdemo_demo`, this will take you to the consul web admin panel.

From here we can see that the `dockerdemo_demo` container has been discovered and registered in consul.  If the health status is green then everything worked.
You can also verify by going to http://127.0.0.1/dockerdemo_demo/v1. If everything is working you should see:

```json
{"data":"hello world!"}
``` 

What Happened There?
--------------------
We started a Docker Compose file with multiple services in it, two of which were built, `nginx` and our `demo`.  We then started all of the services, upon starting them the `registrator` discovered them via the `docker.sock` socket and added them to consul.  Once added, consul modified the nginx `default.conf` and reloaded nginx.

You can see it happen dynamically by running the following command and refreshing your browser:

```bash
$ docker stop demo
```

This should cause consul to remove the `demo` container.  You can see it get added back by running the `start` command and refreshing your browser.

```bash
$ docker start demo
```

Client Side Service Discovery
-----------------------------
Client Side Service Discovery can be very complex.  It is recommend for the purposes of this tutorial that you read [this article](http://microservices.io/patterns/client-side-discovery.html) as []Netflix OSS](https://netflix.github.io/) is a great example of the client requesting a service and being re-routed properly.

[cssd]: images/cssd.png
[sssd]: images/sssd.png
[nginxsd]: images/nginxsd.png
