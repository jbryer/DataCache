#' Retrieve data from a data cache.
#' 
#' 
#' @param FUN the function used to laod the data.
#' @param frequency how frequently should the cache expire. 
#' @param cache.dir the directory containing the cached data files.
#' @param envir the enviroment into which data will be loaded.
#' @param wait should the function wait until stale data is refreshed.
#' @param ... other parameters passed to \code{FUN}.
#' @seealso \link{daily}, \link{hourly}, \link{weekly}, \link{monthly},
#'        \link{yearly}, \link{nMinutes}, \link{nHours}, \link{nDays}
#' @export
data.cache <- function(FUN,
					  frequency=daily,
					  cache.dir='cache',
					  cache.name='Cache-',
					  envir=parent.frame(),
					  wait=FALSE,
					  ...) {
	if(missing(FUN)) {
		stop('FUN is missing! This parameter defines a function to load data.')
	}
	
	cache.date <- Sys.time()
	return.date <- cache.date
	dir.create(cache.dir, recursive=TRUE, showWarnings=FALSE)
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
					tryCatch({ # TODO: make FUN parameter
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
		load(cinfo[1,]$file, envir=envir)
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
