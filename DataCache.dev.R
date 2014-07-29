require(devtools)

document()
install(quick=TRUE)
build_vignettes()
install()
check()

devtools::install_github('jbryer/DataCache')
vignette('DataCache')
demo('WeatherCache')

knit('vignettes/DataCache.Rmd', 'vignettes/DataCache.md')
