#' Log into enviPath account
#' 
#' @name epLogin
#' 
#' @description
#' epLogin lets you perform login to enviPath. An account is required to use the
#' enviPath API.
#' 
#' @param username \code{Character scalar}. String specifying the username
#' used to log into an enviPath personal account.
#' 
#' @param password \code{Character scalar}. String specifying the password
#' used to log into an enviPath personal account.
#' 
#' @returns
#' A message upon successful login.
#' 
#' @examples
#' \dontshow{
#'     username <- Sys.getenv("EP_USERNAME")
#'     password <- Sys.getenv("EP_PASSWORD")
#'     
#'     is_active <- nzchar(username) && nzchar(password)
#'     
#'     library(httptest2)
#'     start_vignette("httptest/login")
#'     
#'     if( is_active ){
#'         # Clear httptest cache
#'         unlink(
#'             system.file("vignettes/httptest/login"),
#'             recursive = TRUE,
#'             force = TRUE
#'         )
#'     }
#'     
#'     change_state()
#' }
#' # Perform login
#' epLogin(username, password)
#' 
#' # Perform logout
#' epLogout()
#' \dontshow{
#'     end_vignette()
#' }
NULL

#' @export
#' @rdname epLogin
#' @importFrom httr2 request req_method req_body_form req_cookie_preserve
epLogin <- function(username, password){
    # Prepare login request
    req <- request(eP_env$url) |>
        req_method("POST") |>
        req_body_form(
            hiddenMethod  = "login",
            loginusername = username,
            loginpassword = password
        ) |>
        req_cookie_preserve(path = eP_env$cookies)
    # Perform login request
    resp <- .ep_perform(req)
    # Print message upon successful login
    message("Hi nature lover, welcome to enviPath!")
    invisible(NULL)
}

#' @export
#' @rdname epLogin
epLogout <- function(){
    if( file.exists(eP_env$cookies) ){
        file.remove(eP_env$cookies)
        msg <- "Logged out successfully."
    }else{
        msg <- "Already logged out."
    }
    message(msg)
    invisible(NULL)
}

#' @importFrom httr2 req_retry req_error req_perform
.ep_perform <- function(req){
    # Perform request
    resp <- req |>
        req_retry(max_tries = 2) |>
        req_error(is_error = \(resp) FALSE) |>
        req_perform()
    # Check response status
    msg <- switch(
        as.character(resp$status_code),
        "401" = "Not authenticated. Please log into enviPath using epLogin.",
        "403" = "Action failed. Please check that 'smiles' and 'setting' are correct.",
        "404" = "Not found. Please check that 'type' and 'pkg' are correct.",
        "500" = "Authentication failed. Please check your username and password."
    )
    # Raise error if status not ok
    if( !is.null(msg) ) stop(msg, call. = FALSE)
    return(resp)
}
