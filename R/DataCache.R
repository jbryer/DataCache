#' Retrieve data from a data cache.
#' 
#' Data caching is not new. It is often necessary to save intermediate data
#' files when the process of loading and/or manipulating data takes a
#' considerable amount of time. This problem is further complicated when working
#' with dynamic data that changes regularly. In these situations it often
#' sufficient to use data that is current with in some time frame (e.g. hourly,
#' daily, weekly, monthly). One solution is to use a time-based job scheduler
#' such as cron. However, that requires access and knowledge of Unix systems.
#' The alternative, is to check for the “freshness” of a cached dataset each
#' time it is requested. If is “stale,” then the data cached is refreshed with
#' more up-to-date data. The DataCache package implements this approach in R.
#' Moreover, on Unix systems (including Mac OS X), the refreshing will be done
#' in the background. That is, when requesting data from the cache, if it is
#' stale, the function will return the latest available data while the cache is
#' updated in the background. This is particularly useful when using R in a web
#' environment (e.g. Shiny Apps) where it is not ideal to have the user wait for
#' data be loaded to begin interacting with the app.
#' 
#' @param FUN the function used to laod the data.
#' @param frequency how frequently should the cache expire.
#' @param cache.dir the directory containing the cached data files.
#' @param envir the enviroment into which data will be loaded.
#' @param wait should the function wait until stale data is refreshed.
#' @param ... other parameters passed to \code{FUN}.
#' @seealso \link{daily}, \link{hourly}, \link{weekly}, \link{monthly}, 
#'   \link{yearly}, \link{nMinutes}, \link{nHours}, \link{nDays}
#' @export
data.cache <- function(FUN,
					  frequency=daily,
					  cache.dir='cache',
					  cache.name='Cache',
					  envir=parent.frame(),
					  wait=FALSE,
					  ...) {
	if(missing(FUN)) {
		stop('FUN is missing! This parameter defines a function to load data.')
	}
	
	cache.date <- Sys.time()
	return.date <- cache.date
	if(!file.exists(cache.dir)) {
		dir.create(cache.dir, recursive=TRUE, showWarnings=FALSE)
		cache.dir <- normalizePath(cache.dir)
	}
	cinfo <- cache.info(cache.dir=cache.dir, cache.name=cache.name, stale=NULL)
	new.cache.file <- paste0(cache.dir, '/', cache.name, cache.date, '.rda')
	
	if(nrow(cinfo) > 0 & Sys.info()['sysname'] != 'Windows' & !wait) {
		if(frequency(cinfo[1,]$created)) { # Check to see if the cache is stale
			lock.file <- paste0(cache.dir, '/', cache.name, '.lck')
			if(!file.exists(lock.file)) {
				now <- Sys.time()
				save(now, file=lock.file)
				p <- parallel:::mcfork(TRUE)
				if(inherits(p, "masterProcess")) {
					sink(file=paste0(cache.dir, '/', cache.name, cache.date, '.log'), append=TRUE)
					print(paste0('Loading data at ', Sys.time()))
					tryCatch({
							thedata <- FUN(...)
							if(class(thedata) == 'list') {
								save(list=ls(thedata), envir=as.environment(thedata), 
									 file=new.cache.file)
							} else {
								save(thedata, file=new.cache.file)
							}							
							sink()
						},
						error = function(e) {
							print(e)
						},
						finally = {
							unlink(lock.file)
							parallel:::mcexit()							
						}
					)
					invisible(new.cache.file)
				}
			} else {
				finfo <- file.info(lock.file)
				message(paste0('Data is being loaded by another process. ',
							   'The process has been running for ',
							   difftime(Sys.time(), finfo$ctime, units='secs'),
							   ' seconds. If this is an error delete ', lock.file))
			}
			message('Loading more recent data, returning lastest available.')
		}
		load(paste0(cache.dir, '/', cinfo[1,]$file), envir=envir)
		return.date <- cinfo[1,]$created
	} else {
		if(Sys.info()['sysname'] == 'Windows' & nrow(cinfo) == 0) {
			message('Background processing is not supported on Windows. Loading new data...')
		} else if(wait) {
			message('Loading new data...')
		} else {
			message('No cached data found. Loading intial data...')
		}
		sink(file=paste0(cache.dir, '/', cache.name, cache.date, '.log'), append=TRUE)
		print(paste0('Loading data at ', Sys.time()))
		thedata <- FUN(...)
		if(class(thedata) == 'list') {
			save(list=ls(thedata), envir=as.environment(thedata), 
				 file=new.cache.file)
		} else {
			save(thedata, file=new.cache.file)
		}
		sink()
		load(new.cache.file, envir=envir)			
	}
	
	invisible(return.date)
}
