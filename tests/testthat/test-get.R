
with_mock_dir("../httptest/get", {
    
    test_that("get", {
        
        rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
        
        expect_error(
            epGet("wrong", BPPARAM = BPPARAM),
            "'type' must be one of the listable elements returned by epTypes.",
            fixed = TRUE
        )
        
        expect_error(
            epGet("reaction", "wrong", BPPARAM = BPPARAM),
            "Not found. Please check that 'type' and 'pkg' are correct.",
            fixed = TRUE
        )
        
        rxn <- epGet("reaction", rxn_id, BPPARAM = BPPARAM)
        
        expect_type(rxn, "list")
        expect_length(rxn, 15L)
    })
})
