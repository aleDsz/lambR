HomeController <- R6Class("HomeController", inherit = Controller, 
	public = list(
		boot = function () {
			name <- private$model$get_name()

			return (list(
				text = name
			))
		}
	)
)
