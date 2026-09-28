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
#'     
#'     library(httptest2)
#'     start_vignette("httptest/model")
#'     change_state()
#'     
#'     if( is_active ){
#'         # Perform login
#'         epLogin(username, password)
#'         # Clear httptest cache
#'         unlink(
#'             system.file("vignettes/httptest/model"),
#'             recursive = TRUE,
#'             force = TRUE
#'         )
#'     }
#' }
#' library(igraph)
#' library(ggraph)
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
#' \dontshow{
#'     end_vignette()
#' }
NULL

#' @export
#' @rdname epModel
#' @importFrom httr2 request req_method req_url_path_append req_body_form req_cookie_preserve resp_body_json
epModel <- function(smiles, setting = NULL){
    
    if( smiles == "" ){
        stop("'smiles' must be a valid SMILES representation.", call. = FALSE)
    }
    
    if( is.null(setting) ) setting <- "1d915a48-286a-4394-9693-bfaa187326a5"
    
    setting <- paste0("https://envipath.org/setting/", setting)
    
    req <- request(eP_env$url) |>
        req_method("POST") |>
        req_url_path_append("util") |>
        req_body_form(smiles = smiles, settingUri = setting) |>
        req_cookie_preserve(path = eP_env$cookies)
    
    resp <- .ep_perform(req)
    
    out <- resp_body_json(resp, simplifyVector = TRUE)
    
    if( is.data.frame(out$edges$rule) ){
        out$edges$ruleId <- out$edges$rule$uuid
        out$edges$ruleName <- out$edges$rule$name
        out$edges$rule <- NULL
    }
    
    out$nodes$name <- out$nodes$smiles
    out$nodes$smiles <- NULL
    
    out$nodes <- out$nodes[c("id", "name", "depth")]
    return(out)
}