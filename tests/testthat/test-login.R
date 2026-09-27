
test_that("login", {
    
    expect_error(
        epLogin("username"),
        'argument "password" is missing, with no default',
        fixed = TRUE
    )
    
    expect_error(
        epLogin("wrong_user", "wrong_pass"),
        "Authentication failed. Please check your username and password.",
        fixed = TRUE
    )
    
    expect_message(epLogin(username, password), "Hi .+, welcome to enviPath!")
})