
library(httptest2)

username <- Sys.getenv("EP_USERNAME")
password <- Sys.getenv("EP_PASSWORD")

is_active <- nzchar(username) && nzchar(password)

if( is_active ){
    # Log into enviPath
    epLogin(username, password)
    # Clear httptest cache
    unlink(
        system.file("tests/testthat/httptest"),
        recursive = TRUE,
        force = TRUE
    )
}
