% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.kclustering.R
\name{plot.kclustering}
\alias{plot.kclustering}
\title{Plot k-means clustering from a 'kclustering' object}
\usage{
\method{plot}{kclustering}(x, title = NULL, ncol.arrange = NULL, min.mid.max = NULL, ...)
}
\arguments{
\item{x}{an object of class \code{kclustering}}

\item{title}{Plot title}

\item{ncol.arrange}{integrer, number of columns when arranging multiple grobs on a page}

\item{min.mid.max}{numeric vector with 3 elements: lower bound, middle dashed line, upper bound for radial axis}

\item{...}{other graphical parameters}
}
\value{
A single plot or a list of \code{ggplot2} radial plots
}
\description{
Plot k-means clustering from a 'kclustering' object
}
\examples{
FF <- fourfactors(Tbox,Obox)
X <- with(FF, data.frame(OD.Rtg=ORtg/DRtg,
               F1.r=F1.Def/F1.Off, F2.r=F2.Off/F2.Def,
               F3.O=F3.Def, F3.D=F3.Off))
X$P3M <- Tbox$P3M
X$STL.r <- Tbox$STL/Obox$STL
kclu1 <- kclustering(X)
plot(kclu1)
kclu2 <- kclustering(X, k=9)
plot(kclu2)
}
\references{
P. Zuccolotto and M. Manisera (2020) Basketball Data Science: With Applications in R. CRC Press.
}
\seealso{
\code{\link{kclustering}}, \code{\link{radialprofile}}
}
\author{
Marco Sandri, Paola Zuccolotto, Marica Manisera (\email{basketballanalyzer.help@unibs.it})
}
