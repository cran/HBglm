\name{HBglm}
\alias{HBglm}
\alias{hbglm}

\alias{hbglm.sampler.control}
\alias{hbglm.model.control}

\alias{print.hbglm}
\alias{predict.hbglm}
\alias{coef.hbglm}
\alias{summary.hbglm}
\alias{print.summary.hbglm}

\title{Hierarchical Bayesian Regression for GLMs}

\description{
Convenient and efficient functions for performing 2-level HB regressions analysis for multi-group data. The lowest level may belong to the GLM family while the prior level, which effects pooling, allows for linear regression on lower level covariates. Constraints on all or part of the parameter set maybe specified with ease. A rich set of methods is included to visualize and analyze results.
}

\usage{
hbglm(formula, data, formula.fixed = NULL,
      family = "gaussian", 
      sampler.control = hbglm.sampler.control(),
      model.control = hbglm.model.control(),
      ncores = 1, print.level = 0, ...)
hbglm.sampler.control(num.samples = -1, samp.factor = 50, 
    sampler = c("slice"))
hbglm.model.control(constraints = NULL, 
    initializer = c("user", "regression"), user.init.val = NULL)
\method{print}{hbglm}(x, digits = max(3, getOption("digits") -2),
                         width = getOption("width"), nburnin = 0, ...)
\method{predict}{hbglm}(object, newdata = NULL, grpID.col = NULL,
                   type = c("link", "response", "ppp.mean", "ppp.dist"),
                   nburnin = 0, times = 0, print.level = 0, ...)
\method{coef}{hbglm}(object, nburnin = 0, ...)
\method{summary}{hbglm}(object, nburnin = 0, ...)
\method{print.summary}{hbglm}(x, digits = max(3, getOption("digits") -2),
                                  width = getOption("width"), ...)
}
\arguments{
    \item{formula}{formula object or string specifying the model to be estimated (see Note).}
    \item{data}{A data.frame object with data organized in the 'long' format or as a list of lists (see Note).}
    \item{formula.fixed}{formula specifying the fixed effects included in the model.}
    \item{family}{Name of a GLM family member. Currently allowed "gaussian", "binomial", "poisson" with standard link functions.}
    \item{sampler.control}{List to control MCMC sampling.}
    \item{model.control}{List to specify initial values, constraints.}
    \item{ncores}{Number of cores to run on. Currently fixed at 1.}
    \item{print.level}{Positive integer to print stuff while running.}
    \item{num.samples}{Number of MCMC samples to draw. Default '-1' will cause internal default values to kick-in.}
    \item{samp.factor}{Used in setting internal default for number of MCMC samples to draw. Must be a positive integer}
    \item{sampler}{Name of MCMC sampler to use. Currently fixed at the slice sampler.}
    \item{constraints}{User specified constraints.}
    \item{initializer}{How to obtain initial values.}
    \item{user.init.val}{User specified initial values.}
    \item{x, object}{A hbglm class object.}
    \item{width}{Printing control options.}
    \item{nburnin}{Number of burn-in samples. These samples, starting fromt the initial, are discarded from print, summary and predict.}
    \item{digits}{Printing control options.}
    \item{newdata}{Same format as data argument. Used in predction.}
    \item{grpID.col}{Name of column in data which has group information for each observation.}
    \item{type}{Used in predict. 'link' and 'response' are non-Bayesian predictions and return the avg response on the linear predictor and the response scale, respectively. They are computed by using model coefficients obtained by averaging MCMC samples. 'ppp.mean' return the distribution of means of the response posterior predcitive probability (PPP) distribution. 'ppp.dist' returns samples drawn from the full response PPP distribution.}
    \item{times}{Used in predict when type = 'ppp.dist' to specify number of samples desired from the response PPP distribution. When 0, a default internal value is used.}
    \item{...}{Currently unused.}
}   

\value{
    An object of class hbglm, with elements:
    \item{formula}{the model formula object}
    \item{formula.fixed}{the fixed effects formula object}
    \item{nsamples}{the number of samples drawn}
    \item{model.control}{list of model control args}
    \item{sampler.control}{list of sampler control args}
    \item{grpID.col}{Data column with grp ID information}
    \item{call}{the hbglm function call that user made, }
    \item{model}{List with number of parameters and model matrices}
    \item{family}{List with functions such as loglikelihood and inverse link for the GLM family.}
    \item{samples}{A list with the MCMC samples drawn; organized by coeff type.}
}

\note{
1. The data must be in the 'long' or the 'list' format. In 'list' format there must bebe 2 keys 'lower' and 'upper' specifying two data.frames for the lower and upper level models respectively. Lower level contains data related to the fixed and random effects, while upper level contains data about the groups. In 'long' the 'upper' and 'lower' level data must be consolidated in a single data.frame (the upper level data will have to suitably replicated).

2. The 'formula' argument should  be specified  in the format: responseVar ~ choice specific variables with generic coefficients | individual specific variables | choice specific variables with choice specific coefficients. These are the 3 available variable types.

3. Random effects are mandatory in the formula. 
}

\author{Asad Hasan, Alireza S. Mahani}
\keyword{Hierarchical, Bayesian, regression, multilevel}

\examples{
  library(HBglm)
  data("linear_list", package = "HBglm")
  fm <- formula(y ~ x1 + x2 + x3 - 1 | z1 + z2 + z3 - 1 | grpID)
  fm.fixed <- formula(y ~ f1 + f2)
  samp.control = hbglm.sampler.control(num.samples = 20)
  \dontrun{
    fit <- hbglm(fm, linear_list, formula.fixed = fm.fixed, family="gaussian",
                sampler.control = samp.control, print.level=0)
    print(fit)
  }
}
