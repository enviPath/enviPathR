#' List enviPath objects
#' 
#' @name epList
#' 
#' @description
#' epList returns a list with info on objects available in enviPath.
#' 
#' @param type \code{Character scalar}. String specifying the object type to
#'   listed.
#' 
#' @param pkg \code{Character scalar}. String specifying the unique identifier
#'   of the package from which objects should be listed. When null, all
#'   available packages are used. (Default: \code{NULL})
#' 
#' @returns
#' A data frame with all objects belonging to \code{type} in \code{pkg}.
#' 
#' @details
#' For transparency, the performed raw API call can be accessed with
#' \code{attr(x, "call")}, where \code{x} is the output of \code{epList}.
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
#' # List packages
#' pkg_df <- epList("package")
#' 
#' # Select reviewed packages
#' to_keep <- pkg_df$reviewStatus == "reviewed"
#' pkg_df <- pkg_df[to_keep, ]
#' 
#' # Remove lengthy description
#' pkg_df$description <- NULL
#' 
#' # View some packages
#' head(pkg_df)
#' 
#' # Select desired package
#' pkg_name <- "EAWAG-BBD"
#' pkg_id <- pkg_df$id[pkg_df$name == pkg_name]
#' 
#' # List pathways from desired package
#' path_df <- epList("pathway", pkg = pkg_id)
#' 
#' # View some pathways
#' head(path_df)
#' }
NULL

#' @export
#' @rdname epList
#' @importFrom httr2 req_url_path_append req_cookie_preserve resp_url resp_body_json
#' @importFrom stringi stri_replace_first_regex
epList <- function(type, pkg = NULL){
    # Check type
    .check_type(type)
    # Check pkg
    is_pkg <- .check_pkg(pkg)
    # Check type and pkg combo
    if( type == "package" && is_pkg ){
        stop("'pkg' cannot be defined when listing packages.", call. = FALSE)
    }
    # Initialise request and preserve cookies
    req <- request(eP_env$url) |>
        req_cookie_preserve(eP_env$cookies)
    # Append package id to call url
    if( is_pkg ) req <- req_url_path_append(req, "package", pkg)
    # Append object type to call url
    req <- req_url_path_append(req, type)
    # Perform query
    resp <- .ep_perform(req)
    # Retrieve result from response
    out <- resp_body_json(resp, simplifyVector = TRUE)
    # Extract data.frame
    df <- out[[1L]]
    # Remove id prefix
    df$id <- stri_replace_first_regex(df$id, ".*/", "")
    # Select relevant variables to keep
    to_keep <- c("name", "id")
    # Include review status except for type setting
    if( type != "setting" ) to_keep <- c(to_keep, "reviewStatus")
    # Add package-specific stats
    if( type == "package" ){
        # Retrieve object types
        obj.types <- names(df$links[[1L]])
        # Count objects for each type
        obj.counts <- vapply(obj.types, .extract_obj_counts, numeric(nrow(df)), df)
        # Combine object counts into table
        df <- cbind(df, obj.counts)
        # Add description and object counts to relevant variables
        to_keep <- c(to_keep, "description", obj.types)
    }
    # Select relevant columns
    df <- df[ , to_keep]
    # Store raw API call in corresponding attribute
    attr(df, "call")$url <- resp_url(resp)
    return(df)
}


.check_type <- function(type){
    # Check type format
    if( is.null(type) || length(type) != 1L || !type %in% epTypes()$listable ){
        stop(
            "'type' must be one of the listable elements returned by epTypes.",
            call. = FALSE
        )
    }
}


.check_pkg <- function(pkg){
    # Check if pkg exists
    is_pkg <- !is.null(pkg)
    # Check pkg format
    if( is_pkg && (length(pkg) != 1L || !is.character(pkg)) ){
        stop(
            "'pkg' must be a single character string specifying a package ",
            "unique identifier.", call. = FALSE
        )
    }
    return(is_pkg)
}


.extract_obj_counts <- function(obj.type, df){
    
    counts <- vapply(
        df$links,
        function(x){ y <- unlist(x[[obj.type]]); as.numeric(y[[2L]]) },
        FUN.VALUE = numeric(1L)
    )
    
    return(counts)
}
