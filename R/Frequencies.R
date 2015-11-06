#' Refresh the cache now.
#' 
#' This function will always return TRUE therefore causing the cache to always
#' be refreshed.
#' 
#' @param timestamp the timestamp to test whether the cache is stale.
#' @return Always returns TRUE.
#' @family frequencies
#' @export 
now <- function(timestamp) {
	return(TRUE)
}

#' Refresh data hourly.
#' 
#' This function will return TRUE when the data cache is stale and the data should
#' be refreshed. Essentially this will return TRUE after the top of each hour.
#' For example, if the last cache was created at 9:59 and then called again at
#' 10:01, this function will return TRUE. If you wish to refresh every, say, 60
#' minutes, use the \code{\link{nMinutes}} function.
#' 
#' @param timestamp the timestamp to test whether the cache is stale.
#' @return Returns TRUE if the the cache is stale.
#' @family frequencies
#' @export
hourly <- function(timestamp) {
	now <- Sys.time()
	return(hour(now) > hour(timestamp) |
		   day(now) > day(timestamp) | 
		   month(now) > month(timestamp) | 
		   year(now) > year(timestamp))
}

#' Refresh data yearly.
#' 
#' @inheritParams hourly
#' @family frequencies
#' @export
yearly <- function(timestamp) {
	now <- Sys.time()
	return(year(now) > year(timestamp))
}

#' Refresh data monthly.
#' 
#' @inheritParams hourly
#' @family frequencies
#' @export
monthly <- function(timestamp) {
	now <- Sys.time()
	return(month(now) > month(timestamp) | 
		   year(now) > year(timestamp))
}

#' Refresh data weekly.
#' 
#' This function will return TRUE when the data cache is stale and the data should
#' be refreshed.
#' 
#' @inheritParams hourly
#' @family frequencies
#' @export
weekly <- function(timestamp) {
	now <- Sys.time()
	return(week(now) > week(timestamp) |
		   year(now) > year(timestamp))
}

#' Refresh data daily.
#' 
#' This function will return TRUE when the data cache is stale and the data should
#' be refreshed.
#' 
#' @inheritParams hourly
#' @family frequencies
#' @export
daily <- function(timestamp) {
	now <- Sys.time()
	return(day(now) > day(timestamp) | 
		   month(now) > month(timestamp) | 
		   year(now) > year(timestamp))
}

#' Refresh every n days.
#' 
#' @param nDays number of days (minimally) between updates.
#' @family frequencies
#' @export
nDays <- function(nDays) {
	return(nMintues(24 * 60 * nDays))
}

#' Refresh every n hours.
#' 
#' @param nHours number of hours (minimally) between updates.
#' @family frequencies
#' @export
nHours <- function(nHours) {
	return(nMinutes(60 * nHours))
}

#' Refresh every n minutes.
#'
#' @param minutes number of minutes (minimally) between updates.
#' @family frequencies
#' @export
nMinutes <- function(minutes) {
	fun <- function(timestamp) {
		return(difftime(Sys.time(), timestamp, units='mins') > minutes)
	}
	return(fun)
}
