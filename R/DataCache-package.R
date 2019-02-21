#' Package for managing data caches
#' 
#' Data caching is not new. It is often necessary to save intermediate data
#' files when the process of loading and/or manipulating data takes a
#' considerable amount of time. This problem is further complicated when working
#' with dynamic data that changes regularly. In these situations it often
#' sufficient to use data that is current with in some time frame (e.g. hourly,
#' daily, weekly, monthly). One solution is to use a time-based job scheduler
#' such as \code{cron}. However, that requires access and knowledge of Unix systems.
#' The alternative, is to check for the "freshness" of a cached dataset each
#' time it is requested. If is "stale," then the data cached is refreshed with
#' more up-to-date data. The \code{DataCache} package implements this approach in R.
#' Moreover, on Unix systems (including Mac OS X), the refreshing will be done
#' in the background. That is, when requesting data from the cache, if it is
#' stale, the function will return the latest available data while the cache is
#' updated in the background. This is particularly useful when using R in a web
#' environment (e.g. Shiny Apps) where it is not
#' ideal to have the user wait for data be loaded to begin interacting with the
#' app.
#' 
#' See the Vignette for more information: \code{vignette('DataCache')}.
#' 
#' @name DataCache-package
#' @docType package
#' @title Package for managing data caches
#' @author \email{jason@@bryer.org}
#' @keywords data cache
#' @import parallel lubridate stats
NA

.onAttach <- function(libname, pkgname) {
	if(Sys.info()['sysname'] == 'Windows') {
		packageStartupMessage('Background data loading (i.e. forking) is not supported on Windows.')
	}
}

