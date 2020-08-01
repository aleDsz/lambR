Logger <- R6Class("Logger",
	public = list(
		info = function (...) {
			list(...) %>%
				private$get_message() %>%
				loginfo()
		},

		debug = function (...) {
			list(...) %>%
				private$get_message() %>%
				logdebug()
		},

		warn = function (...) {
			list(...) %>%
				private$get_message() %>%
				logwarn()
		},

		error = function (...) {
			list(...) %>%
				private$get_message() %>%
				logerror()
		}
	),

	private = list(
		get_message = function (data) {
			if (!is.null(data$func)) {
				func <- data$func
			} else {
				func <- "LOGGER"
			}

			data$func <- NULL
			format <- "[%s]:: %s"

			message <-
				data %>%
				as.character() %>%
				paste(sep = "", collapse = " ")

			format %>%
				sprintf(func, message) %>%
				return()
		}
	)
)

Logger <- Logger$new()
