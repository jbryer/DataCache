#' Retrieve data from a data cache.
#' 
#' 
#' @param FUN the function used to laod the data.
#' @param cache.dir the directory containing the cached data files.
#' @param envir the enviroment into which data will be loaded.
#' @param ... other parameters passed to \code{FUN}.
#' @export
cacheData <- function(FUN,
					  frequency=hourly,
					  cache.dir='cache', 
					  envir=parent.frame(),
					  ...) {
	if(missing(FUN)) {
		stop('FUN is missing! This parameter defines a function to load data.')
	}
	
	cache.date <- Sys.time()
	file.prefix <- 'Cache-'
	dir.create(cache.dir, recursive=TRUE, showWarnings=FALSE)
	cache.files <- list.files(paste0(cache.dir, '/'), '*.rda')	
	panel.cache <- paste0(cache.dir, '/', file.prefix, cache.date, '.rda')
	
	if(file.exists(panel.cache)) {
		load(panel.cache, envir=envir)
	} else {
		if(length(cache.files) > 0 & Sys.info()['sysname'] != 'Windows') {
			lock.file <- paste0(cache.dir, '/dataacache.lck')
			if(!file.exists(lock.file)) {
				now <- Sys.time()
				save(now, file=lock.file)
				p <- parallel:::mcfork(TRUE)
				if(inherits(p, "masterProcess")) {
					sink(file=paste0(cache.dir, '/', file.prefix, cache.date, '.log'), append=TRUE)
					print(paste0('Loading data at ', Sys.time()))
					tryCatch({ # TODO: make FUN parameter
							thedata <- FUN(...)
							save(list=ls(thedata), envir=as.environment(thedata), file=panel.cache)
						},
						error = function(e) {
							print(e)
						},
						finally = {
							unlink(lock.file)
							parallel:::mcexit()							
						}
					)
					invisible(panel.cache)
				}
			} else {
				message(paste0('Data is being loaded by another process. ',
							   'If this is an error delete ', lock.file))
			}
			message(paste0('Loading more recent data, returning lastest available: ',
						   cache.files[length(cache.files)]))
			load(paste0(cache.dir, '/', cache.files[length(cache.files)]), envir=envir)
		} else {
			if(Sys.info()['sysname'] == 'Windows' & length(cache.files) == 0) {
				message('Background processing is not supported on Windows. Loading new data...')
			} else {
				message('No cached data found. Loading intial data...')
			}
			sink(file=paste0(cache.dir, '/', file.prefix, cache.date, '.log'), append=TRUE)
			thedata <- FUN(...)
			sink()
			save(list=ls(thedata), envir=as.environment(thedata), file=panel.cache)
			load(panel.cache, envir=envir)			
		}
	}
	
	invisible(cache.date)
}
