#' Plot simple regression
#'
#' @param x An object of class 'simplereg'
#' @param labels Labels for the subjects (optional)
#' @param subset Subset of subjects to be highlighted in the graph  (optional) - or 'quant' to highligh the upper and lower quantiles
#' @param Lx Active in case of subset='auto'; specify the lower quantiles of x to display - default = 0.01
#' @param Ux Active in case of subset='auto'; specify the upper quantiles of x to display - default = 0.99
#' @param Ly Active in case of subset='auto'; specify the lower quantiles of y to display - default = 0.01
#' @param Uy Active in case of subset='auto'; specify the upper quantiles of y to display - default = 0.99
#' @param title Plot title
#' @param xtitle Label of x-axis
#' @param ytitle Label of y-axis
#' @param repel Text labels repel away from each other
#' @param ... Other graphical parameters
#' @examples
#' Pbox.sel <- subset(Pbox, MIN >= 500)
#' X <- Pbox.sel$AST/Pbox.sel$MIN
#' Y <- Pbox.sel$TOV/Pbox.sel$MIN
#' Pl <- Pbox.sel$Player
#' mod <- simplereg(x=X, y=Y, type="lin")
#' plot(mod)
#' @method plot simplereg
#' @export
#' @importFrom stats coef
#' @importFrom stats quantile
#' @importFrom ggplot2 geom_abline

plot.simplereg <- function(x, labels = NULL, subset = NULL, Lx = 0.01, Ux = 0.99, Ly = 0.01,
                      Uy = 0.99, title = NULL, xtitle = NULL, ytitle = NULL, repel = TRUE, ...) {

  if (!is.simplereg(x)) {
    stop("Not a 'simplereg' object")
  }
  label <- y <- NULL
  xx <- x[["x"]]
  yy <- x[["y"]]
  type = x[["type"]]
  mod <- x[["Model"]]
  R2 <- x[["R2"]]
  R2text <- paste(round(R2, 4) * 100, "*'%'", sep = "")

  if (is.null(title)) {
    title <- "Simple regression"
  }

  if (is.null(labels)) {
    labels <- as.character(1:length(xx))
  }

  df1 <- data.frame(x = xx, y = yy, label = labels)

  if (!is.null(subset)) {
    if (subset[1] == "quant") {
      subset <- which(xx < stats::quantile(xx, Lx) | xx > stats::quantile(xx, Ux) | yy <
                        stats::quantile(yy, Ly) | yy > stats::quantile(yy, Uy))
    }
  }
  df2 <- df1[subset, ]

  p <- ggplot(data = df1, aes(x = x, y = y)) + geom_point()


  if (repel) {
    p <- p + geom_text_repel(data = df2, aes(x = x, y = y, label = label), color = "blue")
  } else {
    p <- p + geom_text(data = df2, aes(x = x, y = y, label = label), color = "blue")
  }

  if (type == "lin") {
    b <- coef(mod)
    p <- p + geom_abline(slope = b[2], intercept = b[1], lwd = 1, color = "lightsteelblue4")
    if (b[2] > 0) {
      lbl <- paste("'Y =", round(b[1], 2), "+", round(b[2], 2), "X'*~~~~~~~~ R^2 ==",
                   R2text)
    } else {
      lbl <- paste("'Y =", round(b[1], 2), "-", round(abs(b[2]), 2), "X'*~~~~~~~~ R^2 ==",
                   R2text)
    }
    if (cor(df1$x, df1$y) > 0) {
      p <- p + geom_text(aes(x = min(x), y = max(y), label = lbl), hjust = 0,
                         color = "lightsteelblue4", parse = T)
    } else {
      p <- p + geom_text(aes(x = max(x), y = max(y), label = lbl), hjust = 1,
                         color = "lightsteelblue4", parse = T)
    }
  } else if (type == "pol") {
    idx <- order(xx)
    df3 <- data.frame(x = xx[idx], y = mod$fitted[idx])
    print(paste("R^2 = ", R2text, sep = ""))
    p <- p + geom_line(data = df3, aes(x = x, y = y), color = "olivedrab3", lwd = 1) +
      geom_text(aes(x = min(x), y = max(y), label = paste("R^2 ==", R2text)),
                hjust = 0, color = "olivedrab3", parse = T)
  } else if (type == "ks") {
    p <- p + geom_line(aes(x = mod$x, y = mod$y), color = "olivedrab3", lwd = 1) +
      geom_text(aes(x = min(x), y = max(y), label = paste("R^2 ==", R2text)),
                hjust = 0, color = "olivedrab3")
  }

  p <- p + labs(title = title, x = xtitle, y = ytitle)

  print(p)
  invisible(p)

}