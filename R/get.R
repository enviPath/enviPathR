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
#' @returns
#' A list of objects
#' 
#' @examples
#' \dontshow{
#'     username <- Sys.getenv("EP_USERNAME")
#'     password <- Sys.getenv("EP_PASSWORD")
#'     
#'     is_active <- nzchar(username) && nzchar(password)
#'     
#'     start_vignette("httptest/get")
#'     change_state()
#'     
#'     if( is_active ){
#'         # Perform login
#'         epLogin(username, password)
#'         # Clear httptest cache
#'         unlink(
#'             system.file("vignettes/httptest/get"),
#'             recursive = TRUE,
#'             force = TRUE
#'         )
#'     }
#' }
#' rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#' 
#' epGet("reaction", rxn_id)
#' \dontshow{
#'     end_vignette()
#' }
NULL

#' @export
#' @rdname epGet
#' @importFrom BiocParallel bpmapply
epGet <- function(type, init = NULL, pkg = NULL, property = NULL){
    
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    
    if( is.null(init) ) init <- epList(type, pkg)$id
    
    out <- bpmapply(
        .ep_get,
        init,
        MoreArgs = list(type = type, pkg = pkg, property = property),
        SIMPLIFY = FALSE
    )
    
    if( length(out) == 1L ) out <- out[[1L]]
    
    return(out)
} 

#' @importFrom httr2 request req_url_path_append req_cookie_preserve resp_body_json
.ep_get <- function(init, type, pkg, property = NULL){
    
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, type, init) |>
        req_cookie_preserve(path = eP_env$cookies)
    
    if( !is.null(property) ) req <- req_url_path_append(req, property)
    
    resp <- .ep_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    return(out)
}
