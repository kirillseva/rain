kunteynir [![Build Status](https://travis-ci.org/peterhurford/batchman.svg?branch=master)](https://travis-ci.org/kirillseva/kunteynir) ![Release Tag](https://img.shields.io/github/tag/kirillseva/kunteynir.svg)
===========

Convert a tundraContainer into a dockerized REST server.

Available routes:
-----
HTTP request | endpoint                     | response
-------------|------------------------------|---------
GET/POST     | /                            | "OK"
GET/POST     | /ping                        | "pong"
GET/POST     | /predict (with JSON payload) | serialized output of predict as JSON

Usage
----
```r
model <- readRDS("path/to/model/object")
build_image(model, "mySuperGlmModel") # use docker hub, default options
build_image(model, "veryCustomized", "myregistry.com",
  "path/to/dockerfile", "path/to/server/script") # custom registry and configs
```
