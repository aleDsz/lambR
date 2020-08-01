# lambR project
# 
# Stating the application, autoloading all dependencies
if (requireNamespace("readr", quietly=TRUE)) {
	source("app/autoload.R")
} else {
  message("Install readr to load all dependencies")
}
