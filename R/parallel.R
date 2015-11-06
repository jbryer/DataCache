# These functions are from the parallel package.

#' Copied from parallels package.
#' 
#' Internal function
#' 
#' @param estranged estranged
# mcfork <- function (estranged = FALSE) {
# 	r <- .Call(C_mc_fork, estranged)
# 	processClass <- if (!r[1L]) 
# 		"masterProcess"
# 	else if (is.na(r[2L])) 
# 		"estrangedProcess"
# 	else "childProcess"
# 	structure(list(pid = r[1L], fd = r[2:3]), class = c(processClass, 
# 														"process"))
# }

#' Copied from parallels package.
#' 
#' Internal function
#' 
#' @param exit.code exit.code
#' @param send send
# mcexit <- function (exit.code = 0L, send = NULL) {
# 	if (!is.null(send)) 
# 		try(sendMaster(send), silent = TRUE)
# 	.Call(C_mc_exit, as.integer(exit.code))
# }
