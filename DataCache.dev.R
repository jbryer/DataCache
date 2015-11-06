require(devtools)

setwd('~/Dropbox/Projects')

document('DataCache')
check_doc('DataCache')
install('DataCache', quickin=TRUE)
#build_vignettes('DataCache')
build('DataCache')
install('DataCache')
check('DataCache')


librdevtools::install_github('jbryer/DataCache')
vignette('DataCache')
demo('WeatherCache')


knitr::knit('DataCache/doc/DataCache.Rmd', 'DataCache/vignettes/DataCache.Rmd')
