#' Returns information about the cache.
#' 
#' @param cache.dir the directory containing the cached files.
#' @param units the units to use for calculate the age of the cache file.
#' @param stale a vector of frequencies to test whether the each cache file
#'        is stale.
#' @return a data frame with three columns: the cached file name, the date/time
#'         created, and the age in the specified units (default is minutes).
#' @export
cache.info <- function(cache.dir='cache', units='mins', 
					   stale=c('hourly'=hourly, 'daily'=daily, 'weekly'=weekly, 'monthly'=monthly)) {
	if(any(is.null(stale)) | any(names(stale) == '')) {
		stop("stale must be a named vector (e.g. stale=c(hourly=hourly)")
	}
	results <- data.frame()
	if(file.exists(cache.dir)) {
		file.prefix <- 'Cache-'
		cache.files <- list.files(paste0(cache.dir, '/'), '*.rda')
		if(length(cache.files) > 0) {
			timestamps <- substr(cache.files, 
								 nchar(file.prefix) + 1,
								 sapply(cache.files, nchar) - 4)
			results <- data.frame(file=paste0(cache.dir, '/', cache.files),
								  created=as.POSIXct(timestamps),
								  age=as.numeric(difftime(Sys.time(), timestamps, units=units)))
			names(results)[3] <- paste0('age_', units)
			for(i in seq_along(stale)) {
				results[,paste0(names(stale)[i], '_stale')] <- stale[[i]](timestamps)
			}
		}
	}
	return(results)
}
