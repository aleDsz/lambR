readRenviron("./.env")

App <- R6Class ("Application",
  public = list(
    real_path = NA,
    router = NULL,
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
				LEVEL = Sys.getenv(paste0(enviroment_type, "LEVEL")),
        DB_NAME = Sys.getenv(paste0(enviroment_type, "DB_NAME")),
        DB_HOST = Sys.getenv(paste0(enviroment_type, "DB_HOST")),
        DB_PORT = Sys.getenv(paste0(enviroment_type, "DB_PORT")),
        DB_USER = Sys.getenv(paste0(enviroment_type, "DB_USER")),
        DB_PASSWORD = Sys.getenv(paste0(enviroment_type, "DB_PASSWORD")),
        DB_TYPE = Sys.getenv(paste0(enviroment_type, "DB_TYPE")),
        ENV_TYPE = Sys.getenv(paste0(enviroment_type, "ENV_TYPE")),
        APP_HOST = Sys.getenv(paste0(enviroment_type, "APP_HOST")),
        APP_PORT = as.numeric(Sys.getenv(paste0(enviroment_type, "APP_PORT")))
      )

			self$environments$BASE_URL <- paste0(
				"http://",
				self$environments$APP_HOST,
				":",
				self$environments$APP_PORT,
				"/"
			)

			logging::setLevel(self$environments$LEVEL)
      
      private$plumber <- plumber$new()
      private$autoload()
    },
    
    get_router = function (App) {
      self$router <- Router$new(private$plumber, App)
      return (self$router)
    }
  ),
  
  private = list(
    plumber = NULL,
    
    source_file = function (folders) {
      for (folder in folders) {
        if (dir.exists(folder)) {
          for (file in list.files(folder, full.names = T, include.dirs = T)) {
            if (dir.exists(file)) {
              private$source_file(file)
            } else {
              source(file)
            }
          }
        } else if (file.exists(folder)) {
        	source(folder)
        }
      }
    },
    
    autoload = function () {
      source("./utils/logger.R")
      source("./app/web_processor.R")
      source("./app/router.R")
      source("./app/controller.R")
      source("./app/model.R")
      
      folders <- c(
        "./app/controllers/",
        "./app/models/"
      )
      
      private$source_file(folders)
    }
  )
)
