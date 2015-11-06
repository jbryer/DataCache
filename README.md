#### DataCache: R Package for Managing Data Caches

[![Build Status](https://api.travis-ci.org/jbryer/DataCache.svg)](https://travis-ci.org/jbryer/DataCache?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/DataCache)](http://cran.r-project.org/package=DataCache)


The latest development version can be installed using the `devtools` package:

```
devtools::install_github('jbryer/DataCache')
```

#### Example

This example will load weather data.

```
library('weatherData')
library('DataCache')

loadWeatherData <- function(station_id='ALB') {
	return(list(weather=getDetailedWeather(station_id, Sys.Date())))
}

cacheData(loadWeatherData)
cache.info()
cache.info(stale=c('2mins'=nMinutes(2)))
```

Wait two minutes so the cache becomes stale.

```
Sys.sleep(120)
cacheData(loadWeatherData, nMinutes(2))
```
