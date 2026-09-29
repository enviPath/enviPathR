#' Find available enviPath resources
#' 
#' @name epTypes
#' 
#' @description
#' epTypes retrieves the set of listable and linkable enviPath object types
#' 
#' @returns
#' A list with two elements:
#' \itemize{
#'   \item listable: a character vector of the object types supported by \code{\link{epList}}
#'   \item linkable: a data frame of links between object types supported by \code{\link{epLink}}
#' }
#' 
#' @examples
#' # Retrieve available resources
#' types <- epTypes()
#' 
#' # View listable object types
#' types$listable
#' 
#' # View linkable object types
#' types$linkable
NULL

#' @export
#' @rdname epTypes
#' @importFrom stringr str_split fixed
epTypes <- function(){
    # Retrieve links between object types
    links <- eP_env$links |>
        names() |>
        str_split(fixed("2"), simplify = TRUE) |>
        as.data.frame()
    # Give names to link columns
    colnames(links) <- c("from", "to")
    # Create list with listable and linkable
    out <- list(listable = eP_env$dbs, linkable = links)
    return(out)
}
