
library(httptest2)
# Retrieve login credentials
username <- Sys.getenv("EP_USERNAME")
password <- Sys.getenv("EP_PASSWORD")
# Check if login credentials exist
is_active <- nzchar(username) && nzchar(password)
# If login credentials exist
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
# Redact httptest output
set_redactor(function (x) {
    # Remove address prefix
    x <- gsub_response(x, "envipath.org/api/legacy/", "")
    # Reduce unique identifiers
    x <- gsub_response(x, "/(?:[0-9a-z]+-){2,}[0-9a-z]+/", "_")
    return(x)
})
# Add parent directory to httptest paths
.mockPaths("../")
