\name{make_step}
\alias{make_step}
\alias{make_step_continuous}
\alias{make_step_deterministic}
\alias{make_step_equilibrium}
\alias{make_step_mutation_limited}
\title{Step System Forward in Time}
\usage{
make_step(fitness, mutation, dt, mu, y_initial)

make_step_continuous(fitness, mutation, dt, mu, y_initial, ...)

make_step_deterministic(fitness, ...)

make_step_equilibrium(fitness, ..., method)

make_step_mutation_limited(step_equilibrium, mutation, mu, y_initial)
}
\arguments{
  \item{fitness}{Function for computing fitness.  Must take
  arguments \code{x_new} (phenotypes to compute fitness
  for), \code{x} (resident phenotypes) and \code{y}
  (resident abundances) and return the per-capita growth
  rate (g).  The population will step forward with an Euler
  step, so that the new \code{y} will be \code{y + y * g *
  dt}.}

  \item{mutation}{Function for generating mutants.  Must
  take arguments \code{traits} (resident phenotypes) and
  \code{mutants} (the number of mutants to generate, for
  each phenotype).  See \code{\link{make_mutation}}, which
  generates a useful function.}

  \item{dt}{Size of the time step}

  \item{mu}{Mutation rate.  On average there will be
  \code{mu*dt*y} mutations, with the actual number drawn
  from Poisson distribution.}

  \item{y_initial}{Abundance at which to introduce new
  mutants.}

  \item{method}{method to find equilibrium.  Must be one of
  "runsteady" or "nleqslv" (or a contraction).}

  \item{...}{Additional arguments passed through to either
  \code{rootSolve::runsteady} or \code{nleqslv::nleqslv}.}

  \item{step_equilibrium}{Function generated by
  \code{make_step_equilibrium}.}
}
\value{
A Function that moves the system forward in time; it takes
a list with elements \code{x} (traits), \code{y}
(abundances) and \code{t} (time) and returns a list with
these updated to the next steps.
}
\description{
Build a function that steps the system through one
generation. Order of events is: (1) resolve fitness (2)
introduce mutants.

\code{make_step_equilibrium} does a very simple minded
attempt to converge on the equilibrium of a system by
running it for a long time.  It advances the system by
\code{dt} (should be a largeish number) a number of times
until the population size stabilises. This could be
replaced by a multidimensional root finding approach.
}
\author{
Rich FitzJohn
}

