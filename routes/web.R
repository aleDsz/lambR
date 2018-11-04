index.html <- read_file("./public/index.html")
view <- NA

Router$handle("GET", "/", function () {
    return (gsub("<app></app>", "USE THIS", index.html, fixed = T))
}, serializer = serializer_html())
