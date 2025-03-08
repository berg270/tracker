# Analysis functions

#' Returns a dataframe with extra columns with dynamical information
#'
#' @param data_loc The clean data from a given location
#'
#' @return A data frame including the speeds and accelerations
#' @export
#'
#' @seealso \code{\link{speed}, \link{accel}}
#'
append_dynamics <- function(data_loc) {
  # Directional dynamical data
  speeds <- speed(data_loc$time, data_loc$x, data_loc$y)
  accels <- accel(data_loc$time, data_loc$x, data_loc$y)

  # Absolute dynamical data
  aspeed <- sqrt(speeds$vx^2 + speeds$vy^2)
  aaccel <- sqrt(accels$ax^2 + accels$ay^2)

  # Paste everything together
  data <- cbind(data_loc, speeds, aspeed, accels, aaccel)
}

#' Return speeds
#'
#' @param t The times vector
#' @param x The x positions
#' @param y The y positions
#'
#' @return The speeds
#' @export
#'
#' @seealso \code{\link{accel}}
#'
speed <- function(t, x, y) {
  # Turn data into function...
  x_fun <- splinefun(t, x)
  y_fun <- splinefun(t, y)

  # ... so numDeriv can be used to differentiate
  vx <- numDeriv::grad(x_fun, t)
  vy <- numDeriv::grad(y_fun, t)

  speeds <- data.frame(vx, vy)
}


#' Return accelerations
#'
#' @param t The times vector
#' @param x The x positions
#' @param y The y positions
#'
#' @return The accelerations
#' @export
#'
#' @seealso \code{\link{speed}}
#'
accel <- function(t, x, y) {
  # First get speeds...
  speeds <- speed(t, x, y)

  # ... and then differentiate again, as in previous function
  vx_fun <- splinefun(t, speeds$vx)
  vy_fun <- splinefun(t, speeds$vy)

  ax <- numDeriv::grad(vx_fun, t)
  ay <- numDeriv::grad(vy_fun, t)

  accels <- data.frame(ax, ay)
}


#' Returns a dataframe with rows filtered
#'
#' @param input_data The clean data from all locations
#' @param filter_location The location on which the data will be filtered
#'
#' @return A data frame including only the rows belonging to one location
#' @export
#'
filter_data <- function(input_data, filter_location){
  input_data %>% filter(location == filter_location) 
}


#' Returns a dataframe with extra columns with polar coordinates
#'
#' @param data_loc The clean data from a given location
#'
#' @return A data frame including the polar coordinates
#' @export
#'
#' @seealso \code{\link{speed}, \link{accel}}
#'
append_polar_coordinates <- function(data_loc) {
  
  # Calculate min and max of x and y coordinates
  max_x <- max(data_loc$x)
  min_x <- min(data_loc$x)
  max_y <- max(data_loc$y)
  min_y <- min(data_loc$y)
  
  # Calculate center of the petridish
  r_0_x <- mean(c(max_x, min_x))
  r_0_y <- mean(c(max_y, min_y))
  
  # Correct the coordinates according to the center of the petridish
  x_r <- data_loc$x-r_0_x
  y_r <- data_loc$y-r_0_y
  
  # Calculate the polar coordinates
  r <- sqrt(x_r^2+y_r^2)
  th <- atan2(y = y_r, x = x_r)
  
  # Calculate the cumulative distance traveled
  d <- cumsum(r)
  
  # Paste everything together
  data <- cbind(data_loc, x_r, y_r, r, th, d)
}