context("netest")

test_that("netest works for edges only model", {
  nw <- network.initialize(n = 50, directed = FALSE)
  est <- netest(
    nw,
    formation = ~ edges,
    dissolution = ~offset(edges),
    target.stats = 25,
    coef.diss = dissolution_coefs(~offset(edges), 10, 0),
    verbose = FALSE)
  expect_is(est, "netest")
})


test_that("netest works for edges + nodematch model", {
  nw <- network.initialize(n = 50, directed = FALSE)
  nw <- set.vertex.attribute(nw, "race", rbinom(50, 1, 0.5))
  est <- netest(
    nw,
    formation = ~ edges + nodematch("race"),
    dissolution = ~offset(edges),
    target.stats = c(25, 10),
    coef.diss = dissolution_coefs(~offset(edges), 10, 0),
    verbose = FALSE)
  expect_is(est, "netest")
})


test_that("netest works with offset.coef terms", {
  nw <- network.initialize(100, directed = FALSE)
  nw <- set.vertex.attribute(nw, "role", rep(c("I", "V", "R"), c(10, 80, 10)))
  est <- netest(nw,
                formation = ~ edges +
                              offset(nodematch('role', diff = TRUE, keep = 1:2)),
                coef.form = c(-Inf, -Inf),
                target.stats = c(40),
                dissolution = ~offset(edges),
                coef.diss = dissolution_coefs(~offset(edges), 52*2, 0.0009),
                verbose = FALSE)
  expect_is(est, "netest")
})


test_that("netest works for heterogeneous dissolutions", {
  nw <- network.initialize(100, directed = FALSE)
  nw <- set.vertex.attribute(nw, "race", rbinom(50, 1, 0.5))
  est <- netest(
    nw,
    formation = ~edges + nodematch("race"),
    dissolution = ~ edges + nodematch("race"),
    target.stats = c(50, 20),
    coef.diss = dissolution_coefs(~offset(edges) + offset(nodematch("race")), c(10, 20)),
    verbose = FALSE
  )
  expect_is(est, "netest")
})
