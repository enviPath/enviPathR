
with_mock_dir("../httptest/model", {
    
    test_that("model", {
        
        expect_error(
            epModel(""),
            "'smiles' must be a valid SMILES representation.",
            fixed = TRUE
        )
        
        expect_error(
            epModel("wrong"),
            "Action failed. Please check that 'smiles' and 'setting' are correct.",
            fixed = TRUE
        )
        
        smiles <- "ClC(Cl)=C(Cl)Cl"
        former_out <- epModel(smiles)
        
        expect_type(former_out, "list")
        
        expect_named(former_out, c("nodes", "edges"))
        
        expect_contains(names(former_out$nodes), c("name", "id"))
        expect_contains(names(former_out$edges), c("from", "to"))
    })
})
