#' @author aleDsz
#' @import R6
#' @import plumber
NULL

#' @include filter.R
CORS <- R6Class("CORS",
  parent_env = .GlobalEnv,
  inherit = Filter,

  public = list(
    call = function () {
      res$setHeader("Access-Control-Allow-Origin", "*")
      res$setHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, PUT, DELETE, OPTIONS")
      res$setHeader("Access-Control-Allow-Headers", "Origin, Content-Type, X-Auth-Token")

      forward()
    }
  )
)
