# Plotting functions


#' Plot positions
#'
#' @param data_loc Clean dataframe corresponding to a location
#' @param type Type of plot (available types: 'scatter', 'density')
#'
#' @return The plot
#' @export
#'
plot_positions <- function(data_loc, type='scatter') {
  
  if (type=='scatter') {
    p <- plot(data_loc$x, data_loc$y, pch=19, col=rgb(0, 0, 0, 0.15))
    return(p)
  } else if (type == 'density') {
    if(nrow(data_loc)>5){
      if(sd(data_loc$x)>1){
        k <- kde2d(data_loc$x, data_loc$y, n=100)
        p <- image(k, col = topo.colors(100))
        return(p)
      }
    }
  }
}
