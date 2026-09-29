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
    # Check from
    if( is.null(from) || length(from) != 1L || !from %in% epTypes()$linkable$from ){
        stop(
            "'from' must be one of the linkable elements returned by epTypes.",
            call. = FALSE
        )
    }
    # Check to
    if( is.null(to) || length(to) != 1L || !to %in% epTypes()$linkable$to ){
        stop(
            "'to' must be one of the linkable elements returned by epTypes.",
            call. = FALSE
        )
    }
    # Check pkg
    is_pkg <- .check_pkg(pkg)
    # Set pkg to EAWAG if undefined
    if( is.null(pkg) ) pkg <- "32de3cf4-e3e6-4168-956e-32fa5ddb0ce1"
    # Check init
    is_init <- .check_init(init)
    # Set init to full element list if undefined
    if( is.null(init) ) init <- epList(from, pkg)$id
    # Check rate
    .check_rate(rate)
    # Combine from and to
    by <- paste(from, to, sep = "2")
    # Retrieve specific variable names
    specTo <- eP_env$links[[by]]
    # Link every initial value in parallel
    out <- bplapply(
        init,
        .ep_link,
        from = from, to = specTo, pkg = pkg, rate = rate,
        BPPARAM = BPPARAM
    )
    # Expand to linkmap
    linkmap <- data.frame(
        x = rep(init, lengths(out, use.names = FALSE)),
        y = unlist(out, use.names = FALSE)
    )
    # Set linkmap column names
    colnames(linkmap) <- c(from, to)
    # Remove missing values
    linkmap <- linkmap[complete.cases(linkmap[[to]]), ]
    # Return empty linkmap for no bindings
    if( nrow(linkmap) == 0L ){
        warning("No bindings found", call. = FALSE)
        return(linkmap)
    }
    # Remove structure identifier for compounds
    if( by == "pathway2compound" ){
        linkmap[to] <- str_remove(linkmap[[to]], "/structure/.*")
    }
    # Remove id prefix
    linkmap[to] <- str_remove(linkmap[[to]], ".*/")
    return(linkmap)
}


#' @importFrom httr2 request req_url_path_append req_cookie_preserve req_throttle resp_body_json
.ep_link <- function(init, from, to, pkg, rate){
    # Prepare link request
    req <- request(eP_env$url) |>
        req_url_path_append("package", pkg, from, init) |>
        req_cookie_preserve(path = eP_env$cookies) |>
        req_throttle(rate = rate)
    # Perform request
    resp <- .ep_perform(req)
    # Process response
    out <- resp_body_json(resp, simplifyVector = TRUE)
    # Retrieve specific variables
    out <- out[to[["item"]]] |>
        lapply(`[[`, to[["var"]]) |>
        unlist(use.names = FALSE)
    # Simplify list to single object
    if( is.null(out) ) out <- NA
    return(out)
}


# Define function to check initial values
.check_init <- function(init){
    # Check if pkg exists
    is_init <- !is.null(init)
    # Check pkg format
    if( is_init && !all(is.character(init) & nzchar(init)) ){
        stop(
            "'init' must be a character vector specifying the unique ",
            "identifiers of type 'from' that should be mapped on 'to'.",
            call. = FALSE
        )
    }
    return(is_init)
}


# Define function to check request limiting rate
.check_rate <- function(rate){
    # Check rate format
    if( is.null(rate) || length(rate) != 1L || !is.numeric(rate) ){
        stop(
            "'rate' must be a single integer number specifying the API ",
            "request rate.", call. = FALSE
        )
    }
}
