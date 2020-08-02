context("Router")

test_that("routes is a empty list", {
  router <- Router$new()
  expect_equal(router$routes, list())
})

test_that("make_route is working and route exists", {
  HomeController <- R6Class("HomeController", inherit = Controller)

  router <- Router$new()
  router$make_route("GET", "/", "HomeController", "index")

  route_object <- Route$new(list(
    method = "GET",
    path = "/",
    controller = "HomeController",
    func = "index"
  ))

  route <- router$routes$GET[["/"]]

  expect_equal(route, route_object)
})

test_that("make_route is working and route exists with custom Content-Type", {
  HomeController <- R6Class("HomeController", inherit = Controller)

  router <- Router$new()
  router$make_route(
    "GET", "/", "HomeController",
    "index",
    content_type = "application/json; charset=utf-8"
  )

  route_object <- Route$new(list(
    method = "GET",
    path = "/",
    controller = "HomeController",
    func = "index",
    content_type = "application/json; charset=utf-8"
  ))

  route <- router$routes$GET[["/"]]

  expect_equal(route, route_object)
})

test_that("add_hook is working", {
  TestHook <- R6Class("TestHook", inherit = Middleware, parent_env = .GlobalEnv)

  router <- Router$new()
  router$add_hook("preroute", TestHook$new())

  hook <- router$hooks$preroute[[1]]

  # expect_equal(hook, TestHook)
})

test_that("duplicated routes can't exists and throws an error", {
  HomeController <- R6Class("HomeController", inherit = Controller)

  router <- Router$new()
  router$make_route("GET", "/", "HomeController", "index")

  expect_error(
    router$make_route("GET", "/", "HomeController", "index"),
    "Route for method GET and path / already exists"
  )
})
