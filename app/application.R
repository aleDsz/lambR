library(plumber)
library(R6)
library(readr)

readRenviron("./.env")

App <- R6Class ("Application", list(
    real_path = NA,
    environments = list(),
    is_production = list(),
    
    initialize = function (real_path = getwd()) {
        enviroment_type <- "PRODUCTION_"
        
        if (nchar(Sys.getenv("ENV_TYPE")) > 0) {
            enviroment_type <- paste0(Sys.getenv("ENV_TYPE"), "_")
        }
        
        self$is_production <- grepl("PRODUCTION", enviroment_type, ignore.case = T)
        
        self$real_path <- real_path
        
        self$environments <- list (
            DB_NAME = Sys.getenv(paste0(enviroment_type, "DB_NAME")),
            DB_HOST = Sys.getenv(paste0(enviroment_type, "DB_HOST")),
            DB_PORT = Sys.getenv(paste0(enviroment_type, "DB_PORT")),
            DB_USER = Sys.getenv(paste0(enviroment_type, "DB_USER")),
            DB_PASSWORD = Sys.getenv(paste0(enviroment_type, "DB_PASSWORD")),
            DB_TYPE = Sys.getenv(paste0(enviroment_type, "DB_TYPE")),
            ENV_TYPE = Sys.getenv(paste0(enviroment_type, "ENV_TYPE")),
            APP_HOST = Sys.getenv(paste0(enviroment_type, "APP_HOST")),
            APP_PORT = Sys.getenv(paste0(enviroment_type, "APP_PORT"))
        )
    },
    
    run = function () {
        routes <- plumb(paste0(self$real_path, "/resources/bootstrap.R"))
        routes$run(self$environments$APP_HOST, self$environments$APP_PORT)
    }
))
