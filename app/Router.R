Router <- R6Class("Router",
  public = list(
    routes = list(),
    
    initialize = function (plumber, App) {
			private$processor <- WebProcessor$new(App)
      private$plumber <- plumber
      private$App <- App

			private$plumber$registerHook("preroute", function (req) {
				Logger$info(paste0("Routing a request for ", req$PATH_INFO))
			})
      
      private$plumber$filter("setHeaders", function (res) {
        res$setHeader("Access-Control-Allow-Origin", "*")
        res$setHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, PUT, DELETE, OPTIONS")
        res$setHeader("Access-Control-Allow-Headers", "Origin, Content-Type, X-Auth-Token")
        
        if (!private$App$is_production) {
          res$setHeader("Access-Control-Allow-Origin", "*")
        } else {
          res$setHeader("Access-Control-Allow-Origin", private$App$environments$APP_HOST)
        }
        
        forward()
      })
      
      private$plumber$mount("/assets", PlumberStatic$new("./resources/assets"))
    },
    
    make_web_route = function (route_name, route_path) {
      private$make_route("GET", route_name, route_path, T)
    },
    
    make_api_route = function (route_method, route_name, route_path) {
      private$make_route(route_method, route_name, route_path, F)
    },
    
    run = function (api_host, api_port) {
      private$plumber$run(api_host, api_port)
    }
  ),
  
  private = list(
    App = NULL,
    plumber = NULL,
		processor = NULL,
    
    make_route = function (route_method, route_name, route_path, is_html) {
      private$plumber$handle(route_method, route_path, function (req, res) {
        view_name <- tolower(gsub(".", "/", gsub("_", "/", route_name, fixed = T), fixed = T))
        route_name <- gsub(" ", "", str_to_title(gsub(".", " ", gsub("_", " ", route_name, fixed = T), fixed = T)), fixed = T)
        controller_name <- paste0(route_name, "Controller")
        model_name <- route_name

				Logger$debug("View Name:", view_name)
				Logger$debug("Route Name:", route_name)
				Logger$debug("Controller Name:", controller_name)
				Logger$debug("Model Name:", model_name)

        model <- NULL
        
        model <- eval(parse(
          text = paste0(model_name, "$new()")
        ))
        
        controller <- eval(parse(
          text = paste0(controller_name, "$new(model, req, res)")
        ))

        response <- controller$boot()

        if (is_html) {
          res$setHeader("Content-Type", "text/html; charset=utf-8")
          
          if (file.exists(paste0("./resources/views/", view_name, ".html"))) {
            view <- read_file(paste0("./resources/views/", view_name, ".html"))
          }

          html <- private$processor$process_html(view, response)
          res$body <- private$processor$output(read_file("./public/index.html"), html)
					return (res)
        } else {
          res$setHeader("Content-Type", "application/json; charset=utf-8")
					res$body <- response
          return (res)
        }
      })
    }
  )
)
