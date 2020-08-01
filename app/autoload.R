options(stringsAsFactors = FALSE)

dependencies <- readr::read_file("./DESCRIPTION")
dependencies <- strsplit(dependencies, "\n", fixed = TRUE)[[1]]
dependencies <- dependencies[grepl("    ", dependencies)]
dependencies <- gsub(",", "", dependencies) 

is_everything_installed <- jetpack::check()

load_dependencies <- function (is_everything_installed) {
	if (is_everything_installed) {
		for (dep in dependencies) {
			do.call("library", list(trimws(dep)))
		}
	} else {
		jetpack::install()
	    load_dependencies()
	}
}

load_dependencies(is_everything_installed)
source("./app/app.R")

app <- App$new()
router <- app$get_router(app)

source("resources/bootstrap.R")
