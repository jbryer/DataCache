require(devtools)

setwd('~/Dropbox/Projects')

# Package building
document('DataCache')
check_doc('DataCache')
build('DataCache')
install('DataCache')

# This will build the vignette (from doc directory) and copy to the
# vignettes folder. This will prevent it from building from R CMD CHECK
# which fails.
knitr::knit('DataCache/doc/DataCache.Rmd', 'DataCache/vignettes/DataCache.Rmd')
build_vignettes('DataCache')

check('DataCache')

# Running the package
librdevtools::install_github('jbryer/DataCache')
vignette('DataCache')
demo('WeatherCache')


