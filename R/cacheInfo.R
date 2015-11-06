#' Returns information about the cache.
#' 
#' @param cache.dir the directory containing the cached files.
#' @param cache.name name of the cache.
#' @param units the units to use for calculate the age of the cache file.
#' @param stale a vector of frequencies to test whether each cache file
#'        is stale according to that metric. If \code{NULL}, no info is provided.
#' @return a data frame with three columns: the cached file name, the date/time
#'         created, and the age in the specified units (default is minutes).
#' @export
cache.info <- function(cache.dir='cache', cache.name='Cache', units='mins', 
					   stale=c('hourly'=hourly, 'daily'=daily, 
					   		   'weekly'=weekly, 'monthly'=monthly, 'yearly'=yearly)) {
	if(!is.null(stale) & any(names(stale) == '')) {
		stop("stale must be a named vector (e.g. stale=c(hourly=hourly)")
	}
	results <- data.frame()
	if(file.exists(cache.dir)) {
		cache.files <- list.files(path=cache.dir, pattern=paste0(cache.name, '*'))
		cache.files <- cache.files[grep('*.rda$', cache.files)] # Get only .rda files
		if(length(cache.files) > 0) {
			timestamps <- substr(cache.files, 
								 nchar(cache.name) + 1,
								 sapply(cache.files, nchar) - 4)
			results <- data.frame(file=cache.files,
								  created=as.POSIXct(timestamps),
								  age=as.numeric(difftime(Sys.time(), timestamps, units=units)))
			names(results)[3] <- paste0('age_', units)
			if(!is.null(stale)) {
				for(i in seq_along(stale)) {
					results[,paste0(names(stale)[i], '_stale')] <- stale[[i]](timestamps)
				}
			}
			results <- results[order(results$created, decreasing=TRUE),]
		}
	}
	attr(results, 'cache.dir') <- cache.dir
	return(results)
}
