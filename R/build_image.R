#' Build a docker image with server that serves model$predict
#'
#' Available routes:
#'
#' GET/POST          /            "OK"
#' GET/POST          /ping        "pong"
#' GET/POST          /predict     serialized output of predict as JSON
#'
#' @importFrom productivus pp
#' @export
build_image <- function(model) {
  stopifnot(is(model, "tundraContainer"))
  machine_name <- "syberiaContainer"
  dir <- tempdir(); on.exit(unlink(dir))
  saveRDS(model, paste0(dir, "/model"))
  dockerfile <- write_dockerfile(dir)

  system(paste("docker build -t kirillseva/pshhhh", dir))
  system(paste("docker push kirillseva/pshhhh"))
}

write_dockerfile <- function(dir) {
  template <- readLines(system.file("templates", "Dockerfile", package = "syberiaContainer"))
  writeLines(readLines(system.file("templates", "start_server.R", package = "syberiaContainer")), paste0(dir,"/start_server.R"))
  data <- list(
    model_path = "model",
    start_server_path = "start_server.R"
  )
  writeLines(whisker.render(template, data), paste0(dir, "/Dockerfile"))
}
