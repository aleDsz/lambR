source("routes/web.R")
source("routes/api.R")

Router$run(App$environments$APP_HOST, App$environments$APP_PORT)
