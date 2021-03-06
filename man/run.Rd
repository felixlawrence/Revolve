\name{run}
\alias{run}
\title{Run System}
\usage{
run(sys, n_steps, step, cleanup = identity, print_every = 0)
}
\arguments{
  \item{sys}{a list with elements \code{x} (traits),
  \code{y} (abundances) and \code{t} (time)}

  \item{n_steps}{The number of steps to run the system
  for.}

  \item{step}{Step function (see \code{\link{make_step}})}

  \item{cleanup}{Cleanup function (optional - by default do
  no cleanup)}

  \item{print_every}{Interval at which to print some
  progress information}
}
\description{
Run a system forward in time.
}
\author{
Rich FitzJohn
}

