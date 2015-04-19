kunteynir ![Release Tag](https://img.shields.io/github/tag/kirillseva/kunteynir.svg)
===========

Convert a tundraContainer into a dockerized REST server.

Available routes:
-----
HTTP request | endpoint                     | response
-------------|------------------------------|---------
GET/POST     | /                            | "OK"
GET/POST     | /ping                        | "pong"
GET/POST     | /predict (with JSON payload) | serialized output of predict as JSON
