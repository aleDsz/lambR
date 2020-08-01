source("routes/web.R")
source("routes/api.R")

router$run(app$environments$APP_HOST, app$environments$APP_PORT)
