index.html <- read_file("./public/index.html")
view <- NA

#* @filter set_cors
set_cors <- function(res) {
    res$setHeader("Content-Type", "application/json")
    res$setHeader("Access-Control-Allow-Origin", "*")
    res$setHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, PUT, DELETE, OPTIONS")
    res$setHeader("Access-Control-Allow-Headers", "Origin, Content-Type, X-Auth-Token")

    if (!App$is_production) {
        res$setHeader("Access-Control-Allow-Origin", "*")
    } else {
        res$setHeader("Access-Control-Allow-Origin", App$environments$APP_HOST)
    }

    print (res)

    forward()
}

source("routes/web.R")
source("routes/api.R")
