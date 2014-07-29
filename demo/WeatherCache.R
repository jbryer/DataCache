library('weatherData')
library('DataCache')

#' Load data for a single day for the given airport.
#' @param station_id three letter airport code.
#' @return a list with a data frame names `weather.XXX` where `XXX` is the three
#'         letter airport code.
loadWeatherData <- function(station_id='ALB') {
	results <- list(getDetailedWeather(station_id, Sys.Date()))
	names(results) <- paste0('weather.', station_id)
	return(results)
}

(cache.date <- data.cache(loadWeatherData))
cache.info(stale=c('1mins'=nMinutes(1)))
# Wait one minute so the cache becomes stale.
Sys.sleep(60)
(cache.date <- data.cache(loadWeatherData, nMinutes(1)))
# Run data.cache right away to see that another fork isn't started
(cache.date <- data.cache(loadWeatherData, nMinutes(1)))
cache.info(stale=c('1mins'=nMinutes(1)))
# Wait a few sceonds and we'll get the new data
Sys.sleep(30)
cache.info(stale=c('1mins'=nMinutes(1)))
(cache.date <- data.cache(loadWeatherData, nMinutes(2)))

# We can maintain a separate cache
data.cache(loadWeatherData, cache.name='JFK', station_id='JFK')
cache.info(cache.name='JFK')

# Clean-up the cache
unlink('cache', recursive=TRUE, force=TRUE)
