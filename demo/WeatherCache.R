library('weatherData')
library('DataCache')

#' Load the most up-to-date weather data.
#' @return a list with the
loadWeatherData <- function(station_id='ALB') {
	return(list(weather=getDetailedWeather(station_id, Sys.Date())))
}

cacheData(loadWeatherData)
cache.info()
cache.info(stale=c('2mins'=nMinutes(2)))
# Wait two minutes so the cache becomes stale.
Sys.sleep(120)
cacheData(loadWeatherData, nMinutes(2))
