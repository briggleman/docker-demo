Docker Demo
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

Let's stop that container and remove it so we can see how Docker Compose works.  To remove the image (non-gracefully) go:

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