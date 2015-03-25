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
  cmd <- parse_boot2docker()
  dir <- tempdir(); on.exit(unlink(dir))
  saveRDS(model, paste0(dir, "/model"))
  dockerfile <- write_dockerfile(dir)

  system(paste(cmd, "docker build -t kirillseva/pshhhh", dir))
  system(paste(cmd, "docker push kirillseva/pshhhh"))
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

parse_boot2docker <- function() {
  system('boot2docker init')
  start <- system('boot2docker start', intern = T)
  cmd <- ""
  for (i in 6:8) {
    cmd <- paste(cmd, str_sub(start[i], 12))
  }
  cmd
}
