# ROBODoc

Docker container for running ROBODoc

## Usage

```
docker run --rm \
           -v <SRC_DIR>:/src \
           -v <DOC_DIR>:/doc \
           -e DOCKER_UID=$(id -u) \
           -e DOCKER_GID=$(id -g) \
           andyneff/robodoc:latest <args ...>
```

or using the `docker-compose.yml` file

```
SRC_DIR=<SRC_DIR> DOC_DIR=<DOC_DIR> DOCKER_UID=<UID> DOCKER_GID=<GID> docker-compose run <args ...>
```

- SRC_DIR default is `.`
- DOC_DIR default is `./docs`
- DOCKER_UID default is 1000
- DOCKER_GID default is 1000

### Example 

```
DOCKER_UID=$(id -u) DOCKER_GID=$(id -g) docker-compose run robodoc --multidoc --html
```