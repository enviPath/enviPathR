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
#' @importFrom httr2 req_url_path_append req_cookie_preserve resp_body_json
#' @importFrom stringr str_remove
epList <- function(type, pkg = NULL){
    
    is_pkg <- !is.null(pkg)
    
    if( type == "package" && is_pkg ){
        stop("'pkg' cannot be defined when listing packages.", call. = FALSE)
    }
    
    req <- request(eP_env$url) |>
        req_cookie_preserve(eP_env$cookies)
    
    if( is_pkg ) req <- req_url_path_append(req, "package", pkg)
        
    req <- req_url_path_append(req, type)
    
    resp <- .ep_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    # Extract data.frame
    df <- out[[1L]]
    # Remove id prefix
    df$id <- str_remove(df$id, ".*/")
    
    to_keep <- c("name", "id")
    # Include review status except for type setting
    if( type != "setting" ) to_keep <- c(to_keep, "reviewStatus")
    
    if( type == "package" ){
      
        obj.types <- names(df$links[[1L]])
        obj.counts <- vapply(obj.types, .extract_obj_counts, numeric(nrow(df)), df)
      
        df <- cbind(df, obj.counts)
        to_keep <- c(to_keep, "description", obj.types)
    }
    # Select relevant columns
    df <- df[ , to_keep]
    return(df)
}


.extract_obj_counts <- function(obj.type, df){
    
    counts <- vapply(
        df$links,
        function(x){ y <- unlist(x[[obj.type]]); as.numeric(y[[2L]]) },
        FUN.VALUE = numeric(1L)
    )
    
    return(counts)
}
