#' Package for managing data caches
#' 
#' 
#' 
#' @name DataCache-package
#' @docType package
#' @title Package for managing data caches
#' @author \email{jason@@bryer.org}
#' @keywords data cache
#' @import parallel lubridate
NULL

.onLoad <- function(libname, pkgname) {
	if(Sys.info()['sysname'] == 'Windows') {
		warning('Background data loading (i.e. forking) is not supported on Windows.')
	}
}

.onAttach <- function(libname, pkgname) {
}
