#' Build a docker image with server that serves model$predict and push it to a registry.
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
#' @param name character. name of the resulting docker image
#' @param registry character. Where will you push your image? Leave blank for
#'   pushing to docker hub, or specify your private registry.
#' @param dockerfile character optional. You can specify a custom dockerfile
#'   instead of the default one shipped with kunteynir.
#' @param server_script character optional. You can specify a custom server script
#'   that will be used to start serving the model inside the docker container.
#' @importFrom RDS2 saveRDS
#' @export
build_image <- function(model, name, registry = '', dockerfile = NULL, server_script = NULL, dir = NULL) {
  ## The goal of this package is to provide an easy way for analysts to convert
  ## their models into deployable applications. This is achieved by creating a
  ## Docker image that would serve the model's predictions as a RESTful service.
  ## By default the server will listen on port 8103.

  ## We insist that the model is a tundraContainer.
  ## Check out https://github.com/robertzk/tundra
  stopifnot(is(model, "tundraContainer"))
  if (missing(name)) stop("You need to name your image.")
  if (is.null(dir)) { dir <- tempdir(); on.exit(unlink(dir)) }
  RDS2::saveRDS(model, paste0(dir, "/model"))
  build_args <- list(dir = dir)
  ## You can provide your custom dockerfile and server script, instead of the ones
  ## in `inst/templates`.
  if (!is.null(dockerfile)) build_args$dockerfile <- dockerfile
  if (!is.null(server_script)) build_args$server_script <- server_script
  dockerfile <- do.call(write_dockerfile, build_args)
  if(identical(registry, '')) separator <- '' else separator <- "/"

  cat("Preparing to build: ", registry, separator, name, "\n", sep="")
  ## Build and push to the registry.
  system2("docker", paste0("build -t ", registry, separator, name, " ", dir))
  system2("docker", paste0("push ", registry, separator, name))
}

write_dockerfile <- function(dir,
  dockerfile = system.file("templates", "Dockerfile", package = "kunteynir"),
  server_script = system.file("templates", "start_server.R", package = "kunteynir")) {

  template <- readLines(dockerfile)
  data <- list(
    model_path = "model",
    start_server_path = "start_server.R",
    timestamp = Sys.time()
  )
  writeLines(whisker.render(template, data), paste0(dir, "/Dockerfile"))
  writeLines(readLines(server_script), paste0(dir,"/start_server.R"))
}
