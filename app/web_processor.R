WebProcessor <- R6Class("WebProcessor",
  public = list(
		initialize = function (app) {
			private$app <- app
		},

    process_html = function (html, response) {
			
			if (is.null(response)) {
				return (html)
			}

      html <- gsub("{{ ", "{{", html, fixed = T)
      html <- gsub(" }}", "}}", html, fixed = T)
      
      field_names <- names(response)
      
      for (field_name in field_names) {
        if (!is.list(response[[field_name]]) | !is.data.frame(response[[field_name]]) | !is.R6Class(response[[field_name]]) | !isClass(response[[field_name]])) {
          html <- gsub(paste0("{{", field_name, "}}"), response[[field_name]], html, fixed = T)
        }
      }
      
      return (html)
    },
    
    output = function (index, html) {
			html <- paste0("<app>", html, "</app>")
			html <- gsub("<app></app>", html, index, fixed = T)
			html <- gsub("{{ BASE_URL }}", app$environments$BASE_URL, html, fixed = T)

      return (html)
    }
  ),

	private = list(
		app = NULL
	)
)
