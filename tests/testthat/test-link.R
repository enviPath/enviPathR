
with_mock_dir("httptest/link", {
    
    test_that("link", {
        
        types <- c("compound", "inchikey")
        cpd_id <- "ec87b463-6a3c-4dfa-8b88-4637fc158896"
        
        expect_error(
            epLink("wrong", types[2], cpd_id),
            "'from' must be one of the linkable elements returned by epTypes.",
            fixed = TRUE
        )
        
        expect_error(
            epLink(types[1], types[2], "wrong"),
            "Not found. Please check that 'type' and 'pkg' are correct.",
            fixed = TRUE
        )
        
        cpd2inchikey <- epLink(types[1], types[2], cpd_id)
        
        expect_named(cpd2inchikey, types)
    })
})