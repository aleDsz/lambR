source("app/application.R")

App <- App$new(getwd())
Router <- App$boot()

source("resources/bootstrap.R")
Router$run(App$environments$APP_HOST, App$environments$APP_PORT)
