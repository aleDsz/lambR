source("app/App.R")

App <- App$new(getwd())
Router <- App$get_router(App)

source("resources/bootstrap.R")
