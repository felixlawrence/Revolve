\name{make_parameters}
\alias{make_parameters}
\title{Utility for Parameter Handling}
\usage{
make_parameters(defaults, where = new.env())
}
\arguments{
  \item{defaults}{List of default parameter values.
  Allowable parameter names are also taken from this list}

  \item{where}{Environment into which parameters will be
  set/retrieved.  If ommited a new environment is generated
  (so access is only via get/set).}
}
\value{
An object of class \code{parameters}
}
\description{
Utility for taking care of getting/setting/validating
parameters.
}
\details{
Eventually I'll add a hook here for checking that
parameters are allowable, for setting ranges, etc.
}
\author{
Rich FitzJohn
}

