#' Plots expected points of shots as a function of the distance from the basket (default) or another variable
#'
#' @author Marco Sandri, Paola Zuccolotto, Marica Manisera (\email{basketballanalyzer.help@unibs.it})
#' @param data a data frame whose rows are field shots and with the following columns: \code{points}, \code{event_type}, \code{player} (only if the \code{players} argument is not \code{NULL}) and at least one of \code{playlength}, \code{periodTime}, \code{totalTime}, \code{shot_distance} (the column specified in \code{var}, see Details).
#' @param players subset of players to be displayed (optional; it can be used only if the \code{player} column is present in \code{data}).
#' @param bw numeric, smoothing bandwidth of the kernel density estimator (see \code{\link[stats]{ksmooth}}).
#' @param period.length	numeric, the length of a quarter in minutes (default: 12 minutes as in NBA).
#' @param title character, plot title.
#' @param palette color palette.
#' @param team logical; if \code{TRUE}, draws the expected points for all the shots in data.
#' @param col.team character, color of the expected points line for all the shots in data (default \code{"gray"}).
#' @param col.hline character, color of the dashed horizontal line (default \code{"black"}) denoting the expected points for all the shots in data, not conditional to the variable in the x-axis.
#' @param legend logical, if \code{TRUE}, color legend is displayed (only when \code{players} is not \code{NULL}).
#' @param xlab character, x-axis label.
#' @param var character, a string giving the name of the numerical variable according to which the expected points are estimated; available options \code{"playlength"}, \code{"periodTime"}, \code{"totalTime"}, \code{"shot_distance"} (default).
#' @details The \code{data} data frame could also be a play-by-play dataset provided that rows corresponding to events different from field shots have values different from \code{"shot"} or \code{"miss"} in the \code{even_type} variable.
#' @details Required columns:
#' @details * \code{event_type}, a factor with the following levels: \code{"shot"} for made field shots and \code{"miss"} for missed field shots
#' @details * \code{player}, a factor with the name of the player who made the shot
#' @details * \code{points}, a numeric variable (integer) with the points scored by made shots and \code{0} for missed shots
#' @details * \code{playlength}, a numeric variable with time between the shot and the immediately preceding event
#' @details * \code{periodTime}, a numeric variable with seconds played in the quarter when the shot is attempted
#' @details * \code{totalTime}, a numeric variable with seconds played in the whole match when the shot is attempted
#' @details * \code{shot_distance}, a numeric variable with the distance of the shooting player from the basket (in feet)
#' @references P. Zuccolotto and M. Manisera (2020) Basketball Data Science: With Applications in R. CRC Press.
#' @return A \code{ggplot2} plot
#' @examples
#' PbP <- PbPmanipulation(PbP.BDB)
#' PbP.GSW <- subset(PbP, team=="GSW" & !is.na(shot_distance))
#' plrys <- c("Stephen Curry","Kevin Durant")
#' expectedpts(data=PbP.GSW, bw=10, players=plrys, col.team='dodgerblue',
#'         palette=colorRampPalette(c("gray","black")), col.hline="red")
#' @export

expectedpts <- function(data, players=NULL, bw=10, period.length=12, palette=gg_color_hue, team=TRUE, col.team="gray",
          col.hline="black", xlab=NULL, title=NULL, legend=TRUE, var="shot_distance") {

  event_type <- player <- Player <- NULL
  data <- data %>% dplyr::select(dplyr::one_of(var, "points", "player", "event_type")) %>%
                   dplyr::filter(event_type=="shot" | event_type=="miss")
  x <- data[, var]
  y <- data$points

  if (var=="playlength") {
    xrng <- c(0, 24)
    if (is.null(xlab)) xlab <- "Play length"
    ntks <- 25
  } else if (var=="totalTime") {
    xrng <- c(0, period.length*4*60)
    if (is.null(xlab)) xlab <- "Total time"
    ntks <- 10
  } else if (var=="periodTime") {
    xrng <- c(0, period.length*60)
    if (is.null(xlab)) xlab <- "Period time"
    ntks <- 10
  } else if (var=="shot_distance") {
    if (is.null(xlab)) xlab <- "Shot distance"
    ntks <- NULL
    xrng <- range(data[, var], na.rm=TRUE)
  } else {
    if (is.null(xlab)) xlab <- var
  }

  if (team) {
    ksm <- stats::ksmooth(x=x, y=y, bandwidth=bw, x.points=x, kernel='normal')
    ksm <- as.data.frame(ksm[c("x", "y")])
    ksm$Player <- "Team"
  }

  npl <- 0
  if (!is.null(players)) {
    npl <- length(players)
    kmslst <- vector(npl+1, mode="list")
    for (k in 1:npl) {
      playerk <- players[k]
      datak <- subset(data, player==playerk)
      xk <- datak[, var]
      yk <- datak$points
      ksm_k <- stats::ksmooth(x=xk, y=yk, bandwidth=bw, x.points=xk, kernel='normal')
      ksm_k <- as.data.frame(ksm_k[c("x", "y")])
      ksm_k$Player <- playerk
      kmslst[[k]] <- ksm_k
    }
    if (team) kmslst[[npl+1]] <- ksm
    ksm <- do.call(rbind, kmslst)
    players <- sort(unique(ksm$Player))
    cols <- palette(npl+1)
    cols[players=="Team"] <- col.team
    p <- ggplot(ksm, aes(x=x, y=y, color=Player)) +
      geom_line(lwd=1.5) +
      scale_color_manual(values=cols, breaks=players)
  } else {
    p <- ggplot(ksm, aes(x=x, y=y)) +
      geom_line(color = col.team, lwd=1.5)
  }
  p <- p + geom_hline(yintercept=mean(y), col=col.hline, lty=2, lwd=1.2) +
    labs(x=xlab, y="Expected Points", title=title) +
    theme_bw()
  if (!legend) {
    p <- p + theme(legend.position="none")
  }

  return(p)
}
