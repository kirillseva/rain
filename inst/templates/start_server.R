#!usr/bin/env Rscript
interactive <- function (...) TRUE
library(methods)

model <- readRDS("/root/model")

processSingleDataPoint <- function(datum, model) {
  if (is.list(datum)) {
    datum <- data.frame(denull(datum), stringsAsFactors=FALSE)
  }
  model$predict(datum)
}

denull <- function (lst) {
  Map(function (x) {if (is.null(x)) NA else x}, lst)
}

routes <- list(
  "/ping" = function(...) "pong",
  "/predict" = function(p, q) {
      score <- processSingleDataPoint(p, model)
      score
  },
  function(...) "OK"
)

microserver::run_server(routes, 8103)
