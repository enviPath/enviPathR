
.make_ep_dbs <- function(){
    c("compound", "package", "pathway", "reaction", "rule", "setting")
}

.make_ep_links <- function(){
    list(
        compound2inchikey = c(item = "structures", var = "inchikey"),
        compound2pathway = c(item = "pathways", var = "id"),
        compound2reaction = c(item = "reactions", var = "id"),
        compound2smiles = c(item = "structures", var = "smiles"),
        compound2structure = c(item = "structures", var = "id"),
        pathway2compound = c(item = "nodes", var = "idcomp"),
        pathway2edge = c(item = "links", var = "id"),
        pathway2node = c(item = "nodes", var = "id"),
        pathway2reaction = c(item = "links", var = "idreaction"),
        pathway2structure = c(item = "nodes", var = "idcomp"),
        reaction2compound = list(item = c("educts", "products"), var = "id"),
        reaction2ec = c(item = "ecNumbers", var = "id"),
        reaction2pathway = c(item = "pathways", var = "id"),
        reaction2rhea = c(item = "references", var = "rheaReferences")
    )
}

# Initialise environment
eP_env <- new.env(parent = emptyenv())

#' @importFrom tools R_user_dir
.onLoad <- function(libname, pkgname){
    # Define the API endpoint
    eP_env$url <- "https://envipath.org/api/legacy/"
    # Create cache dir
    cache <- R_user_dir("enviPathR", "cache")
    if( !dir.exists(cache) ) dir.create(cache, recursive = TRUE)
    # Preserve cookies between requests
    eP_env$cookies <- file.path(cache, "cookies.txt")
    # Add database types
    eP_env$dbs <- .make_ep_dbs()
    # Add links
    eP_env$links <- .make_ep_links()
}
