require(devtools)

document()
install(quick=TRUE)
build_vignettes()
install()
check()

