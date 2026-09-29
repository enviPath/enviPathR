#' Predict compound biotransformation pathways
#' 
#' @name epModel
#' 
#' @description
#' epModel predicts the biotransformation pathway for a compound expressed with
#' \code{smiles} using the selected model \code{setting}.
#' 
#' @param smiles \code{Character vector}. String specifying the smiles of a
#'   compound, which does not necessarily have to be available in enviPath.
#' 
#' @param setting \code{Character scalar}. String specifying the unique
#'   identifier of a model setting. When null, the enviFormer setting is used.
#'   (Default: \code{NULL})
#' 
#' @returns
#' A list with two data frames with information on nodes and edges,
#' respectively.
#' 
#' @examples
#' \dontshow{
#'     username <- Sys.getenv("EP_USERNAME")
#'     password <- Sys.getenv("EP_PASSWORD")
#'     
#'     is_active <- nzchar(username) && nzchar(password)
#' }
#' if( is_active ){
#' library(igraph)
#' library(ggraph)
#' 
#' # Perform login with your credentials
#' epLogin(username, password)
#' 
#' # Define smiles of interest
#' smiles <- "ClC(Cl)=C(Cl)Cl"
#' 
#' # Perform pathway prediction with enviFormer
#' former_out <- epModel(smiles)
#' 
#' # List available model settings
#' set_df <- epList("setting")
#' 
#' # View some model settings
#' head(set_df)
#' 
#' # Set id for PEPPER model setting
#' set_name <- "Global Setting - ECC and App Domain - PEPPER"
#' set_id <- set_df$id[set_df$name == set_name]
#' 
#' # Perform pathway prediction with PEPPER
#' pepper_out <- epModel(smiles, set_id)
#' 
#' # Convert model output to igraph object
#' path_graph <- graph_from_data_frame(
#'     pepper_out$edges,
#'     vertices = pepper_out$nodes
#' )
#' 
#' # Visualise predicted pathway
#' plot(path_graph)
#' 
#' # Visualise with ggraph
#' ggraph(path_graph, layout = "sugiyama") +
#'     geom_edge_link(
#'         aes(colour = probability),
#'         arrow = arrow(type = "closed")
#'     ) +
#'     geom_node_point(size = 3) +
#'     geom_node_text(aes(label = name), vjust = 2) +
#'     scale_edge_colour_continuous(
#'         limits = c(0, 1), low = "white", high = "red"
#'     ) +
#'     theme_graph(base_family = "")
#' }
NULL


#' @export
#' @rdname epModel
#' @importFrom httr2 request req_method req_url_path_append req_body_form req_cookie_preserve resp_body_json
epModel <- function(smiles, setting = NULL){
    # Check smiles
    if( !is.character(smiles) || !nzchar(smiles) ){
        stop("'smiles' must be a valid SMILES representation.", call. = FALSE)
    }
    # Check model setting
    is_set <- .check_setting(setting)
    # Set model setting to enviFormer if undefined
    if( is.null(setting) ) setting <- "1d915a48-286a-4394-9693-bfaa187326a5"
    # Prepend model setting with address
    setting <- paste0("https://envipath.org/setting/", setting)
    # Prepare request
    req <- request(eP_env$url) |>
        req_method("POST") |>
        req_url_path_append("util") |>
        req_body_form(smiles = smiles, settingUri = setting) |>
        req_cookie_preserve(path = eP_env$cookies)
    # Perform request
    resp <- .ep_perform(req)
    # Process response
    out <- resp_body_json(resp, simplifyVector = TRUE)
    # Process rule variables
    if( is.data.frame(out$edges$rule) ){
        out$edges$ruleId <- out$edges$rule$uuid
        out$edges$ruleName <- out$edges$rule$name
        out$edges$rule <- NULL
    }
    # Process smiles variable
    out$nodes$name <- out$nodes$smiles
    out$nodes$smiles <- NULL
    # Rename nodes variables
    out$nodes <- out$nodes[c("id", "name", "depth")]
    return(out)
}


# Define function to check model setting
.check_setting <- function(setting){
    # Check if setting exists
    is_set <- !is.null(setting)
    # Check setting format
    if( is_set && (length(setting) != 1L || !is.character(setting)) ){
        stop(
            "'setting' must be a single character string specifying the model ",
            "setting that should be used for the prediction.", call. = FALSE
        )
    }
    return(is_set)
}
