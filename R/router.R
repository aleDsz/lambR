#' @import R6
NULL

#' @description Route object
#' @author aleDsz
#' @exportClass Route
Route <- R6Class("Route",
  parent_env = .GlobalEnv,
  public = list(
    path = NULL,
    method = NULL,
    controller = NULL,
    func = NULL,
    content_type = "text/html; charset=utf-8",

    initialize = function (params = list()) {
      self$path <- params$path
      self$method <- params$method
      self$controller <- params$controller
      self$func <- params$func

      if (!is.null(params$content_type)) {
        self$content_type <- params$content_type
      }
    }
  )
)

#' @description Router class to handle routes from lambR
#' @author aleDsz
#' @include logger.R
#' @include cors.R
#' @exportClass Router
Router <- R6Class("Router",
  parent_env = .GlobalEnv,
  public = list(
    routes = list(),
    hooks = list(),
    filters = list(),

    initialize = function (
      host = "0.0.0.0",
      port = 8000,
      app_dir = ".",
      swagger = FALSE,
      auto_reload = FALSE
    ) {
      private$configurations <- list(
        host = host,
        port = port,
        app_dir = app_dir,
        swagger = swagger,
        auto_reload = auto_reload
      )
    },

    run = function () {
      host <- private$configurations$host
      port <- private$configurations$port
      swagger <- private$configurations$swagger

      private$plumber$run(host, port, swagger = swagger)
    },

    add_hook = function (type, middleware_class) {
      print(middleware_class)
      private$plumber$registerHook(type, middleware_class$call)

      private$hooks[[type]] <- as.list(c(
        private$hooks[[type]],
        middleware_class
      ))
    },

    add_filter = function (name, filter_class) {
      private$plumber$filter(name, function (res) {
        filter_class$call(res)
      })

      private$filters[[name]] <- filter_class
    },

    make_route = function (
      method = "GET",
      path, controller, func,
      content_type = "text/html; charset=utf-8"
    ) {
      route <- Route$new(list(
        method = method,
        path = path,
        controller = controller,
        func = func,
        content_type = content_type
      ))

      if (!private$route_exists(method, path)) {
        private$add_route(route)
      } else {
        stop(sprintf(
          "Route for method %s and path %s already exists",
          method,
          path
        ))
      }
    }
  ),

  private = list(
    plumber = plumber$new(),
    configurations = list(),

    add_route = function (route) {
      method <- self$routes[[route$method]]

      if (is.null(method)) {
        self$routes[[route$method]] <- list()
        self$routes[[route$method]][[route$path]] <- route
      } else {
        self$routes[[route$method]][[route$path]] <- route
      }

      return (TRUE)
    },

    route_exists = function (method, path) {
      if (!is.null(self$routes[[method]])) {
        if (!is.null(self$routes[[method]][[path]])) {
          return (TRUE)
        }
      }

      return (FALSE)
    }
  )
)
