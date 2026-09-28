#' Link enviPath objects
#' 
#' @name epLink
#' 
#' @description
#' epLink returns mappings between enviPath object types.
#' 
#' @param from \code{Character scalar}. String specifying the object type from
#'   which mapping is performed.
#' 
#' @param to \code{Character scalar}. String specifying the object type to which
#'   mapping is performed.
#' 
#' @param init \code{Character vector}. Vector of strings specifying the initial
#'   values of \code{from} that should be mapped to \code{to}. When null, all
#'   objects belonging to \code{from} in \code{pkg} are used.
#'   (Default: \code{NULL})
#' 
#' @param pkg \code{Character scalar}. String specifying the unique identifier
#'   of the package from which objects should be mapped When null, EAWAG-BBD is
#'   used. (Default: \code{NULL})
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
#' A data frame with links between from and to.
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
#' # Link custom reaction to related compounds
#' epLink("reaction", "compound", rxn_id)
#' }
NULL

#' @export
#' @rdname epLink
#' @importFrom BiocParallel bplapply bpparam
#' @importFrom stringr str_remove
#' @importFrom stats complete.cases
epLink <- function(from, to, init = NULL, pkg = NULL, BPPARAM = bpparam(), rate = 5){
    
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    
    if( is.null(init) ) init <- epList(from, pkg)$id
    
    by <- paste(from, to, sep = "2")
    specTo <- eP_env$links[[by]]

    out <- bplapply(
        init,
        .ep_link,
        from = from, to = specTo, pkg = pkg, rate = rate,
        BPPARAM = BPPARAM
    )
    
    linkmap <- data.frame(
        x = rep(init, lengths(out, use.names = FALSE)),
        y = unlist(out, use.names = FALSE)
    )
    
    colnames(linkmap) <- c(from, to)
    
    linkmap <- linkmap[complete.cases(linkmap[[to]]), ]
    
    if( nrow(linkmap) == 0L ){
        warning("No bindings found", call. = FALSE)
        return(linkmap)
    }
    
    if( by == "pathway2compound" ){
        linkmap[to] <- str_remove(linkmap[[to]], "/structure/.*")
    }
    
    # Remove id prefix
    linkmap[to] <- str_remove(linkmap[[to]], ".*/")
    
    return(linkmap)
}


#' @importFrom httr2 request req_url_path_append req_cookie_preserve req_throttle resp_body_json
.ep_link <- function(init, from, to, pkg, rate){
    
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, from, init) |>
        req_cookie_preserve(path = eP_env$cookies) |>
        req_throttle(rate = rate)
    
    resp <- .ep_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    out <- out[to[["item"]]] |>
        lapply(`[[`, to[["var"]]) |>
        unlist(use.names = FALSE)
    
    if( is.null(out) ) out <- NA
    
    return(out)
}

