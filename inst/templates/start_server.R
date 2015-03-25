#!usr/bin/env Rscript
interactive <- function (...) TRUE

model <- readRDS("/root/model")

processSingleDataPoint <- function(datum, model) {
  if (is.list(datum)) {
    datum <- data.frame(denull(datum), stringsAsFactors=FALSE)
  }
  datum <- mungebits::munge(datum, model$munge_procedure)
  model$predict(datum, verbose = TRUE)
}

denull <- function (lst) {
  Map(function (x) {if (is.null(x)) NA else x}, lst)
}

routes <- list(
  "" = function(...) "OK",
  "/ping" = function(...) "pong",
  "/predict" = function(p, q) {
      score <- processSingleDataPoint(p, model)
      list(score = score)
  }
)

microserver::run_server(routes, 8103)
