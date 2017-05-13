# ROBODoc

Docker container for running ROBODoc

## Usage

```
docker run --rm \
           -v <SRC_DIR>:/src \
           -v <DOC_DIR>:/doc \
           andyneff/robodoc:latest <args ...>
```

or using the `docker-compose.yml` file

```
SRC_DIR=<SRC_DIR> DOC_DIR=<DOC_DIR> docker-compose run <args ...>
```

- SRC_DIR default is `.`
- DOC_DIR default is `./Docs`

### Example 

```
docker-compose run robodoc --multidoc --html
```