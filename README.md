rain [![Build Status](https://img.shields.io/travis/kirillseva/rain.svg)](https://travis-ci.org/kirillseva/rain) ![Release Tag](https://img.shields.io/github/tag/kirillseva/rain.svg) [![Documentation](https://img.shields.io/badge/rocco--docs-%E2%9C%93-blue.svg)](http://kirillseva.github.io/rain/)
===========

![logo](http://www.clipartsheep.com/images/377/there-is-35-happy-rain-free-cliparts-all-used-for-clipart.png)

Convert a tundraContainer into a dockerized REST server.

Available routes:
-----
HTTP request | endpoint                     | response
-------------|------------------------------|---------
GET/POST     | /                            | "OK"
GET/POST     | /ping                        | "pong"
GET/POST     | /predict (with JSON payload) | serialized output of predict as JSON

You can customize both your server script and your dockerfile if you need additional functionality.

Usage
----
```r
model <- readRDS("path/to/model/object")
build_image(model, "kirillseva/mySuperGlmModel") # use docker hub, default options
build_image(model, "kirillseva/veryCustomized", "myregistry.com",
  "path/to/dockerfile", "path/to/server/script") # custom registry and configs
```

By default, the server will listen on port 8103. You can run it as following:
`docker run -p 8103:8103 kirillseva/mySuperGlmModel`
