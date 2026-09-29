with_mock_dir("httptest/list", {
        
    test_that("list", {
        
        expect_error(
            epList("wrong"),
            "'type' must be one of the listable elements returned by epTypes.",
            fixed = TRUE
        )
        
        expect_error(
            epList("package", "wrong"),
            "'pkg' cannot be defined when listing packages.",
            fixed = TRUE
        )
        
        expect_error(
            epList("reaction", "wrong"),
            "Not found. Please check that 'type' and 'pkg' are correct.",
            fixed = TRUE
        )
          
        pkg_df <- epList("package")
          
        expect_s3_class(pkg_df, "data.frame")
          
        expect_length(pkg_df, 10L)
    })
})
