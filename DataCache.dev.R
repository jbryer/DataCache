require(devtools)

setwd('~/Dropbox/Projects')

document('DataCache')
check_doc('DataCache')
install('DataCache', quick=TRUE)
build_vignettes('DataCache')
build('DataCache')
install('DataCache')
check('DataCache')



devtools::install_github('jbryer/DataCache')
vignette('DataCache')
demo('WeatherCache')

knit('vignettes/DataCache.Rmd', 'vignettes/DataCache.md')
