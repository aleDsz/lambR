#' @import R6
NULL

#' @author aleDsz
#' @exportClass Filter
Filter <- R6Class("Filter",
  parent_env = .GlobalEnv,
  public = list(
    res = NULL,

    initialize = function (options = list()) {
      private$options <- options
    },

    call = function (res) {
      self$res <- res
      options <- private$options
      return (self$res)
    }
  ),

  private = list(
    options = list()
  )
)
