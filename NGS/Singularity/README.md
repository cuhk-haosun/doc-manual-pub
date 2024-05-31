# Singularity Guidance

___

- [Singularity Guidance](#singularity-guidance)
  - [1 Introduction](#1-introduction)
    - [:mortar\_board: 1.1 What is Singularity](#mortar_board-11-what-is-singularity)
    - [:postbox: 1.2 Why use containers](#postbox-12-why-use-containers)
    - [:sparkles: 1.3 Why use Singularity](#sparkles-13-why-use-singularity)
    - [:books: 1.4 User manual](#books-14-user-manual)
  - [2 Quick Start](#2-quick-start)
    - [:cd: 2.1 Build an image from Dockerfile](#cd-21-build-an-image-from-dockerfile)
    - [:whale: 2.2 Push an image to Docker Hub](#whale-22-push-an-image-to-docker-hub)
    - [:gift: 2.3 Create a container from an image](#gift-23-create-a-container-from-an-image)
    - [:sparkler: 2.4 Execute commands in a container](#sparkler-24-execute-commands-in-a-container)
      - [Method 1: `exec` command](#method-1-exec-command)
      - [Method 2: `shell` command](#method-2-shell-command)

___

## 1 Introduction

### :mortar_board: 1.1 What is Singularity

Singularity is a *container* platform. It allows you to create and run containers that package up pieces of software in a way that is portable and reproducible.

**Main concepts:**

| Concepts          | Descriptions |
| ----------------- | ------------ |
| Image (镜像)      | An image is a **read-only** special file system that provides everything a container needs to run: programs, libraries, resources, configurations, and more.<br><br>You can think of an image as a **snapshot** of an operating system. |
| Container  (容器) | A container is a **instance** of an image, which means that it is **writable**. You can run multiple containers from the same image, and they are isolated from each other.<br><br>Containers can be created, started, stopped and deleted, and share the host operating system kernel but have their own isolated filesystems and (sub)processes.<br><br>Essentially, a started container is a **process** running on your host operating system. |
| Repository (仓库) | A repository is a **storage location for images**. Repositories can be public (accessible by anyone) or private (restricted to specific users or organizations).<br><br>The most common repository is **Docker Hub**, which hosts a large number of **official images**. (Although Singularity also has its cloud library, we usually do not use it.)<br><br>Typically, a repository contains different versions (tags) of the same image. You can specify a specific version of an image using the format `<repository-name>:<tag>`. If no tag is provided, it defaults to `latest`. |

<br>

> An image is *still*, while a container is *alive*.

### :postbox: 1.2 Why use containers

Containers provide a reliable way to maintain consistent application performance across various environments. They encapsulate the application's source code, environment settings, and third-party dependencies into a single image. This image can be used to create containers that run uniformly, regardless of the underlying environment. This approach mitigates issues that arise from discrepancies in environments, configurations, and dependency versions, facilitating seamless cross-platform and cross-server operations and streamlining the transition from development to deployment.

### :sparkles: 1.3 Why use Singularity

Singularity is an open source container platform designed to be simple, fast, and secure. **Unlike Docker which requires root privileges to run containers**, Singularity is designed for ease-of-use on shared multi-user systems and in high performance computing (HPC) environments. **Singularity is compatible with all Docker images** and it can be used with GPUs and MPI applications.

### :books: 1.4 User manual

The latest version of Singularity User Guide is always available through the url: https://docs.sylabs.io/guides/latest/user-guide/

<br>

___

## 2 Quick Start

> Note: Before we start, please make sure that you had installed `docker` and registered an account of Docker Hub. As for how to write a Dockerfile, please check the examples in [another github repository](https://github.com/cuhk-haosun/workshop-docker/tree/main).

### :cd: 2.1 Build an image from Dockerfile

```bash
docker build [OPTIONS] PATH
```

Options used often:

```
-f, --file string                   Name of the Dockerfile (default:
                                      "PATH/Dockerfile")
-t, --tag stringArray               Name and optionally a tag (format:
                                      "name:tag")
```

Supposed that you were already in the directory that had everything necessary for your Dockerfile, you could execute this command to build an image with specified name and tag.

```bash
docker build -t <repository-name>:<tag> .
```

> :exclamation: Note: Because later we need to push this image to Docker Hub, please use `<repository-name>` as the full name of your image, which in fact is the path to your Docker Hub repository and usually looks like this: `<username>/<image-name>`, where `<username>` is your username in Docker Hub.

For example:

```bash
docker build -t QiYifang/minimap2:v1 .
```

After that, you can use `docker images` to list all of the images in your computer.

```bash
runoob@runoob:~$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
mymysql                 v1                  37af1236adef        5 minutes ago       329 MB
runoob/ubuntu           v4                  1c06aa18edee        2 days ago          142.1 MB
<none>                  <none>              5c6e1090e771        2 days ago          165.9 MB
httpd                   latest              ed38aaffef30        11 days ago         195.1 MB
php                     5.6-fpm             025041cd3aa5        3 weeks ago         456.3 MB
python                  3.5                 045767ddf24a        3 weeks ago         684.1 MB
...
```

> Note: It is accessible for us to modify the name and tag of an image by the command `docker tag <IMAGE ID> <new-name>:<new-tag>`.

### :whale: 2.2 Push an image to Docker Hub

It is very convenient to push your image to Docker Hub:

```bash
docker push <repository-name>:<tag>
```

When it is done, you can check your image at Docker Hub website.

![image at Docker Hub](figure/image.png)

### :gift: 2.3 Create a container from an image

To pull an image from Docker Hub and build it into a **sandbox (container in a directory)** in NGS cluster, use the `build --sandbox` command and option:

```bash
singularity build --sandbox </path/container-name> docker://<repository-name>:<tag>
```

This command creates a container in a directory with an isolated Linux filesystem and some Singularity metadata.

> :exclamation: Note: Don't forget to add the `--sandbox` option. Otherwise, Singularity may only pull and build an SIF image, which causes the computing nodes at NGS cluster failed to run it owing to their lack of certain software for converting SIF images into containers.

### :sparkler: 2.4 Execute commands in a container

#### Method 1: `exec` command

The `exec` command allows you to execute a custom command within a container.

```bash
$ singularity exec </path/container-name> echo hello
hello
```

If you pass the `--writable` option, you can also write files within the sandbox directory.

```bash
$ singularity exec --writable </path/container-name> touch /foo

$ singularity exec </path/container-name> ls /foo
/foo
```

#### Method 2: `shell` command

The `shell` command allows you to spawn a new shell within your container and **interact with it** as though it were a virtual machine (And it is writable).

```bash
$ singularity shell </path/container-name>
Singularity>
```
