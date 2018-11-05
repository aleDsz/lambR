Controller <- R6Class("Controller",
    public = list(
        initialize = function (model, request, response) {
            private$model <- model
            private$request <- request
            private$response <- response
        },
        
        boot = function () {
            return (NULL)
        }
    ),
    
    private = list(
        model = NULL,
        request = NULL,
        response = NULL
    )
)
