#' Draws a bar-line plot
#'
#' @author Marco Sandri, Paola Zuccolotto, Marica Manisera (\email{	basketballanalyzer.help@unibs.it})
#' @param data a data frame.
#' @param id character, name of the ID variable.
#' @param bars character vector, names of the bar variables.
#' @param line character, name of the line variable.
#' @param order.by character, name of the variable used to order bars (on the x axis).
#' @param decreasing logical; if \code{TRUE}, decreasing order.
#' @param labels.bars character vector, labels for the bar variables.
#' @param label.line character, label for the line variable on the second y-axis (on the right).
#' @param title character, plot title.
#' @references P. Zuccolotto and M. Manisera (2020) Basketball Data Science: With Applications in R. CRC Press.
#' @return A \code{ggplot2} object
#' @examples
#' dts <- subset(Pbox, Team=="Houston Rockets" & MIN>=500)
#' barline(data=dts, id="Player", bars=c("P2p","P3p","FTp"),
#'         line="MIN", order.by="Player",
#'         labels.bars=c("2P","3P","FT"), title="Houston Rockets")
#' @export
#' @importFrom magrittr "%>%"
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 scale_fill_brewer
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 ggtitle
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 sec_axis
#' @importFrom plyr "."

barline <- function(data, id, bars, line, order.by=id, decreasing=TRUE, labels.bars=NULL, label.line=NULL, title=NULL) {

  Line <- Value <- Variables <- rsum <- x <- y <- ID <- NULL
  if (is.null(labels.bars)) {
    labels.bars=bars
  }
  if (is.null(label.line)) {
    label.line=line
  }

  df1 <- data %>%
    dplyr::select(id, bars, line) %>%
    tidyr::gather(key="Variables", value="Value", bars) %>%
    dplyr::rename(ID=!!id) %>%
    dplyr::mutate(Variables=factor(Variables, levels=bars))

  if (!is.factor(df1$ID)) {
    df1$ID <- factor(df1$ID)
  }

  var_ord <- data[[order.by]]
  if (class(var_ord)=="factor") {
    ord_df1 <- order(levels(var_ord), decreasing=decreasing)
    ord_df2 <- match(levels(df1$ID)[ord_df1], data[[id]])
  } else {
    ord_df2 <- order(var_ord, decreasing=decreasing)
    ord_df1 <- match(data[ord_df2, id], levels(df1$ID))
  }

  df1 <- df1 %>%
    dplyr::mutate(ID=factor(ID,levels=levels(ID)[ord_df1]))

  df2 <- data %>%
    dplyr::select(id, bars, line) %>%
    dplyr::mutate(Line = !!rlang::sym(line)) %>%
    dplyr::rename(ID=!!id) %>%
    dplyr::mutate(rsum=rowSums(dplyr::select(., bars))) %>%
    dplyr::mutate(y=Line*max(rsum)/max(Line)) %>%
    dplyr::slice(ord_df2) %>%
    dplyr::mutate(x=1:dplyr::n())

  p <- ggplot(data=df1, aes(x=ID, y=Value, fill=Variables,
                       text=paste("Team:",ID,"<br>Variable:",Variables))) +
    geom_bar(stat="identity") +
    scale_fill_brewer(labels=labels.bars, palette="Paired") +
    theme(legend.position="top") + ggtitle(title) +
    labs(x="", caption=paste("Bars ordered by",order.by)) +
    theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.25),
          panel.background = element_blank()) +
    geom_line(data=df2, mapping=aes(x=x, y=y), lwd=1.5, col='grey', inherit.aes=F) +
    scale_y_continuous(name="Variables", limits=c(0,NA),
                       sec.axis=sec_axis(~.*max(df2$Line)/max(df2$rsum), name=label.line))
  return(p)
}
