Model <- R6Class("Model",
	public = list(
		get_database_name = function () {
			return (private$database_name)
		},

		get_table_name = function () {
			return (private$table_name)
		}
	),

	private = list(
		connection = NULL,
		database_name = NULL,
		table_name = NULL
	)
)
