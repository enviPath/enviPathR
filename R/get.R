#' Get enviPath objects
#' 
#' @name epGet
#' 
#' @description
#' epGet returns raw objects from enviPath.
#' 
#' @param type \code{Character scalar}. String specifying the object type to be
#'   fetched.
#' 
#' @param init \code{Character vector}. Vector of strings specifying the initial
#'   values of \code{type} that should be fetched. When null, all objects
#'   belonging to \code{type} in \code{pkg} are used. (Default: \code{NULL})
#' 
#' @param pkg \code{Character scalar}. String specifying the unique identifier
#'   of the package from which objects should be fetched. When null, EAWAG-BBD
#'   is used. (Default: \code{NULL})
#' 
#' @param property \code{Character scalar}. String specifying the property to be
#'   fetched from the objects. When null, all elements of the objects are
#'   returned. (Default: \code{NULL})
#' 
#' @param BPPARAM A
#'   \code{\link[BiocParallel:BiocParallelParam-class]{BiocParallelParam}}
#'   object specifying how the requests should be parallelised.
#'   (Default: \code{\link[BiocParallel:register]{bpparam()}})
#' 
#' @param rate \code{Numeric scalar}. Integer number specifying the amount of
#'   requests per second to be sent to the enviPath API when \code{BPPARAM} is
#'   not serial. (Default: \code{5})
#' 
#' @returns
#' A list of objects
#' 
#' @examples
#' \dontshow{
#'     username <- Sys.getenv("EP_USERNAME")
#'     password <- Sys.getenv("EP_PASSWORD")
#'     
#'     is_active <- nzchar(username) && nzchar(password)
#' }
#' if( is_active ){
#' # Perform login with your credentials
#' epLogin(username, password)
#' 
#' # Define custom reaction identifier 
#' rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#' 
#' # Get custom reaction object
#' epGet("reaction", rxn_id)
#' }
NULL

#' @export
#' @rdname epGet
#' @importFrom BiocParallel bpmapply bpparam
epGet <- function(type, init = NULL, pkg = NULL, property = NULL,
    BPPARAM = bpparam(), rate = 5){
    # Check type
    .check_type(type)
    # Check pkg
    is_pkg <- .check_pkg(pkg)
    # Set pkg to EAWAG if undefined
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    # Check init
    is_init <- .check_init(init)
    # Set init to full element list if undefined
    if( is.null(init) ) init <- epList(type, pkg)$id
    # Check rate
    .check_rate(rate)
    # Fetch every initial value in parallel
    out <- bpmapply(
        .ep_get,
        init,
        MoreArgs = list(type = type, pkg = pkg, property = property, rate = rate),
        SIMPLIFY = FALSE,
        BPPARAM = BPPARAM
    )
    # Reduce list to single object
    if( length(out) == 1L ) out <- out[[1L]]
    return(out)
} 

#' @importFrom httr2 request req_url_path_append req_cookie_preserve req_throttle resp_body_json
.ep_get <- function(init, type, pkg, property, rate){
    # Prepare get request
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, type, init) |>
        req_cookie_preserve(path = eP_env$cookies) |>
        req_throttle(rate = rate)
    # Add property if defined
    if( !is.null(property) ) req <- req_url_path_append(req, property)
    # Perform request
    resp <- .ep_perform(req)
    # Process response
    out <- resp_body_json(resp, simplifyVector = TRUE)
    return(out)
}
