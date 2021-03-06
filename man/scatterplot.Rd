% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scatterplot.R
\name{scatterplot}
\alias{scatterplot}
\title{Scatter plot and matrix of scatter plots}
\usage{
scatterplot(
  data,
  data.var,
  z.var = NULL,
  palette = NULL,
  labels = NULL,
  repel_labels = FALSE,
  text_label = TRUE,
  subset = NULL,
  col.subset = "gray50",
  zoom = NULL,
  title = NULL,
  legend = TRUE,
  upper = list(continuous = "cor", combo = "box_no_facet", discrete = "facetbar", na =
    "na"),
  lower = list(continuous = "points", combo = "facethist", discrete = "facetbar", na =
    "na"),
  diag = list(continuous = "densityDiag", discrete = "barDiag", na = "naDiag")
)
}
\arguments{
\item{data}{an object of class \code{data.frame}}

\item{data.var}{character vector, name of variables used on the axes of scatter plots}

\item{z.var}{character, variable name used to assign colors to points}

\item{palette}{color palette}

\item{labels}{character vector, labels for (x, y) points (available only when plotting a single scatter plot)}

\item{repel_labels}{logical; if \code{TRUE}, draw text labels of not highlighted points using repelling}

\item{text_label}{logical; if \code{TRUE}, draw a rectangle behind the labels of highlighted points}

\item{subset}{logical vector, to select a subset of points to be highlighted}

\item{col.subset}{character, color for the subset of highlighted points (available only when plotting a single scatter plot)}

\item{zoom}{numeric vector with 4 elements; \code{c(xmin,xmax,ymin,ymax)} for the x- and y-axis limits of the plot (available only when plotting a single scatter plot)}

\item{title}{character, plot title}

\item{legend}{logical, if \code{legend=FALSE} legend is removed}

\item{upper}{list, may contain the variables \code{continuous}, \code{combo}, \code{discrete}, and \code{na} (See \code{lower} in \code{\link[GGally]{ggpairs}})}

\item{lower}{list, may contain the variables \code{continuous}, \code{combo}, \code{discrete}, and \code{na} (See \code{upper} in \code{\link[GGally]{ggpairs}})}

\item{diag}{list, may contain the variables \code{continuous}, \code{discrete}, and \code{na} (See \code{diag} in \code{\link[GGally]{ggpairs}})}
}
\value{
A \code{ggplot2} plot
}
\description{
Scatter plot and matrix of scatter plots
}
\examples{
# Single scatter plot
Pbox.sel <- subset(Pbox, MIN>= 500)
X <- data.frame(AST=Pbox.sel$AST/Pbox.sel$MIN,TOV=Pbox.sel$TOV/Pbox.sel$MIN)
X$PTSpm <- Pbox.sel$PTS/Pbox.sel$MIN
mypal <- colorRampPalette(c("blue","yellow","red"))
scatterplot(X, data.var=c("AST","TOV"), z.var="PTSpm", labels=1:nrow(X), palette=mypal)
# Matrix of scatter plots
data <- Pbox[1:50, c("PTS","P3M","P2M","OREB","Team")]
scatterplot(data, data.var=1:4, z.var="Team")
}
\references{
P. Zuccolotto and M. Manisera (2020) Basketball Data Science: With Applications in R. CRC Press.
}
\seealso{
\code{\link[GGally]{ggpairs}}
}
\author{
Marco Sandri, Paola Zuccolotto, Marica Manisera (\email{basketball.analyzer.help@gmail.com})
}
