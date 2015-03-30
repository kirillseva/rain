#' Build a docker image with server that serves model$predict
#'
#' Available routes:
#'
#' GET/POST          /            "OK"
#' GET/POST          /ping        "pong"
#' GET/POST          /predict     serialized output of predict as JSON
#'
#' @importFrom productivus pp
#' @param model tundraContainer. A tundra container that contains necessary munge
#'   procedures and the predict function.
#' @param repository character. Where will you push your image?
#' @param dockerfile character optional. You can specify a custom dockerfile
#'   instead of the default one shipped with kunteynir.
#' @param server_script character optional. You can specify a custom server script
#'   that will be used to start serving the model inside the docker container.
#' @export
build_image <- function(model, repository, dockerfile = NULL, server_script = NULL) {
  stopifnot(is(model, "tundraContainer"))
  dir <- tempdir(); on.exit(unlink(dir))
  saveRDS(model, paste0(dir, "/model"))
  build_args <- list(dir = dir)
  if (!is.null(dockerfile)) build_args$dockerfile <- dockerfile
  if (!is.null(server_script)) build_args$server_script <- server_script
  dockerfile <- do.call(write_dockerfile, build_args)

  system2("docker", paste("build -t", repository, dir))
  system2("docker", paste("push", repository))
}

write_dockerfile <- function(dir,
  dockerfile = system.file("templates", "Dockerfile", package = "kunteynir"),
  server_script = system.file("templates", "start_server.R", package = "kunteynir")) {

  template <- readLines(dockerfile)
  data <- list(
    model_path = "model",
    start_server_path = "start_server.R"
  )
  writeLines(whisker.render(template, data), paste0(dir, "/Dockerfile"))
  writeLines(readLines(server_script), paste0(dir,"/start_server.R"))
}
