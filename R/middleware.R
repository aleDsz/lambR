#' @import R6
#' @import plumber
NULL

#' @author aleDsz
#' @exportClass Middleware
Middleware <- R6Class("Middlware",
  parent_env = .GlobalEnv,
  public = list(
    req = NULL,

    initialize = function (options = list()) {
      private$options <- options
    },

    call = function (req) {
      self$req <- req
      options <- private$options
      return (self$req)
    }
  ),

  private = list(
    options = list()
  )
)
