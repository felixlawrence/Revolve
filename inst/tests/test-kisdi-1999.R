source("helper-Revolve.R")

context("Kisdi 1999")

test_that("Model parameters", {
  m <- make_kisdi_1999()

  defaults <- list(c=2, v=1.2, k=4, beta=1, b=1, a=1, m=0, s2=1, d=3.5)
  expect_that(names(m$parameters), equals(names(defaults)))
  expect_that(m$parameters$get(), equals(defaults))

  p_new <- list(c=3)
  m$parameters$set(p_new)
  expect_that(m$parameters$get(), equals(modifyList(defaults, p_new)))

  expect_that(get("c", environment(m$fitness)),
              equals(p_new[["c"]]))
})

test_that("Model components", {
  m <- make_kisdi_1999()
  expect_that(names(m), equals(c("fitness", "competition",
                                 "intrinsic_growth", "parameters")))
  expect_that(m$fitness,      is_a("function"))
  expect_that(m$competition,  is_a("function"))
  expect_that(m$intrinsic_growth,     is_a("function"))
  expect_that(m$parameters,   is_a("parameters"))
})

test_that("Components work", {
  gaussian <- function(x, mean, variance)
    dnorm(x, mean, sqrt(variance)) / dnorm(0, 0, sqrt(variance))
  sigmoid <- function(dx, c, v, k)
    c * (1 - 1 / (1 + v * exp(- k * dx)))

  m_linear   <- make_kisdi_1999("linear")
  m_gaussian <- make_kisdi_1999("gaussian")
  m_convex   <- make_kisdi_1999("convex")

  p_linear   <- m_linear$parameters$get()
  p_gaussian <- m_gaussian$parameters$get()
  p_convex   <- m_convex$parameters$get()

  xx <- seq(-1, 1, length.out=101)
  expect_that(m_linear$intrinsic_growth(xx),
              equals(p_linear$beta - p_linear$b * xx))
  expect_that(m_gaussian$intrinsic_growth(xx),
              equals(p_gaussian$a * gaussian(xx, p_gaussian$m, p_gaussian$s2)))
  expect_that(m_convex$intrinsic_growth(xx),
              equals(-p_convex$a -
                     p_convex$b * (xx - sqrt(xx^2 + p_convex$d))))

  ## Then competition.  In the paper this is plotted as x_new - x;
  ## that is equivalent to competition(0, x_new - x)
  m <- m_linear
  p <- m$parameters$get()
  xp <- 0
  expect_that(m$competition(xx, xp),
              equals(rbind(sigmoid(xx - xp, p$c, p$v, p$k))))
  expect_that(m$competition(xp, xx),
              equals(cbind(sigmoid(xp - xx, p$c, p$v, p$k))))

  expect_that(m$competition(xx, xx),
              equals(sapply(xx, function(xp)
                            sigmoid(xp - xx, p$c, p$v, p$k))))

  zz <- sample(xx, 10)
  expect_that(m$competition(xx, zz),
              equals(sapply(xx, function(xp)
                            sigmoid(xp - zz, p$c, p$v, p$k))))
  expect_that(m$competition(zz, xx),
              equals(sapply(zz, function(xp)
                            sigmoid(xp - xx, p$c, p$v, p$k))))

  ## Now, try this on an established population:
  set.seed(100)
  x <- rnorm(5)
  y <- runif(length(x)) * m$intrinsic_growth(x)

  w.cmp <- m$intrinsic_growth(xp) - sum(y * m$competition(xp, x))
  expect_that(m$fitness(xp, x, y), equals(w.cmp))

  ## Multiple mutants at once:
  set.seed(100)
  xp2 <- rnorm(2)

  w2.cmp <- sapply(xp2, m$fitness, x, y)
  expect_that(m$fitness(xp2, x, y), equals(w2.cmp))
})

test_that("Single species equilibrium", {
  m <- make_kisdi_1999()
  p <- m$parameters$get()

  # Linear: monomorphic singular strategy at
  # beta / b + a(0) /  a'(0)

  alpha <- function(xp) drop(m$competition(0, 0 - xp))
  xp <- p$beta / p$b + alpha(0) / grad(alpha, 0)
  n <- m$intrinsic_growth(xp) / alpha(0)

  ## Growth rate is zero at equilibrium:
  expect_that(m$fitness(xp, xp, n), equals(0))

  ## Fitness gradient is zero at attactor:
  expect_that(grad(function(x) m$fitness(x, xp, n), xp),
              equals(0))
  ## Local minimum (branching point):
  expect_that(hessian(function(x) m$fitness(x, xp, n), xp),
              is_greater_than(0))
})

test_that("Single species equilibrium (gaussian)", {
  m <- make_kisdi_1999("gaussian")
  p <- m$parameters$get()

  alpha <- function(xp) drop(m$competition(0, 0 - xp))

  # Gaussian: monomorphic singular strategy at
  #   m - a'(0) / a(0) * s2
  xp <- p$m - grad(alpha, 0) / alpha(0) * p$s2
  n <- m$intrinsic_growth(xp) / alpha(0)

  ## Growth rate is zero at equilibrium:
  expect_that(m$fitness(xp, xp, n), equals(0))

  ## Fitness gradient is zero at attactor:
  expect_that(grad(function(x) m$fitness(x, xp, n), xp),
              equals(0))
  ## Local minimum (branching point):
  expect_that(hessian(function(x) m$fitness(x, xp, n), xp),
              is_greater_than(0))
})
