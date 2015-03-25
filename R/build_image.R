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
  dokk::machine_local(machine_name); on.exit(dokk::machine_rm(machine_name))
  dir <- tempdir(); on.exit(unlink(dir), add = TRUE)
  saveRDS(model, paste0(dir, "/model"))
  dockerfile <- write_dockerfile(dir)

  dokk::build_image(machine_name, dir, intern = FALSE,
    params = pp("-t kirillseva/pshhhh"))
  flags <- paste0("$(docker-machine config ", machine_name, ")")
  system(paste0("docker ", flags, " push kirillseva/pshhhh"))
}

write_dockerfile <- function(dir) {
  template <- readLines(system.file("templates", "Dockerfile", package = "syberiaContainer"))
  data <- list(
    model_path = paste0(dir, "/model"),
    start_server_path = system.file("templates", "start_server.R", package = "syberiaContainer")
  )
  writeLines(whisker.render(template, data), paste0(dir, "/Dockerfile"))
}
