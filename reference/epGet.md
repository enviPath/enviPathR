# Get enviPath objects

epGet returns raw objects from enviPath.

## Usage

``` r
epGet(
  type,
  init = NULL,
  pkg = NULL,
  property = NULL,
  BPPARAM = bpparam(),
  rate = 5
)
```

## Arguments

- type:

  `Character scalar`. String specifying the object type to be fetched.

- init:

  `Character vector`. Vector of strings specifying the initial values of
  `type` that should be fetched. When null, all objects belonging to
  `type` in `pkg` are used. (Default: `NULL`)

- pkg:

  `Character scalar`. String specifying the unique identifier of the
  package from which objects should be fetched. When null, EAWAG-BBD is
  used. (Default: `NULL`)

- property:

  `Character scalar`. String specifying the property to be fetched from
  the objects. When null, all elements of the objects are returned.
  (Default: `NULL`)

- BPPARAM:

  A
  [`BiocParallelParam`](https://rdrr.io/pkg/BiocParallel/man/BiocParallelParam-class.html)
  object specifying how the requests should be parallelised. (Default:
  [`bpparam()`](https://rdrr.io/pkg/BiocParallel/man/register.html))

- rate:

  `Numeric scalar`. Integer number specifying the amount of requests per
  second to be sent to the enviPath API when `BPPARAM` is not serial.
  (Default: `5`)

## Value

A list of retrieved objects.

## Details

For transparency, the performed raw API calls can be accessed with
`attr(x, "call")`, where `x` is the output of `epGet`.

## Examples

``` r
if( is_active ){
# Perform login with your credentials
epLogin(username, password)

# Define custom reaction identifier 
rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"

# Get custom reaction object
epGet("reaction", rxn_id)
}
#> Hi nature lover, welcome to enviPath!
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$aliases
#> list()
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$description
#> [1] "no description"
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$ecNumbers
#> list()
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$educts
#>             compoundName
#> 1 4-Hydroxybutyraldehyde
#>                                                                                                                                                               id
#> 1 https://envipath.org/package/32de3cf4-e3e6-4168-956e-32fa5ddb0ce1/compound/d2c48ebe-5a5a-4f5b-b42e-8ff23c873f6c/structure/7281d994-9f4a-4f7f-9e50-90b131c11da3
#>      smiles
#> 1 C(CCO)C=O
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$id
#> [1] "https://envipath.org/package/32de3cf4-e3e6-4168-956e-32fa5ddb0ce1/reaction/2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$identifier
#> [1] "reaction"
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$medlineRefs
#> list()
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$multistep
#> [1] FALSE
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$name
#> [1] "Eawag BBD reaction r0014"
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$pathways
#>                                                                                                               id
#> 1 https://envipath.org/package/32de3cf4-e3e6-4168-956e-32fa5ddb0ce1/pathway/c3d1b8d5-9ffb-49b8-a1bf-bf3d7dfd1ac3
#>              name reviewStatus identifier
#> 1 Tetrahydrofuran     reviewed    pathway
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$products
#>         compoundName
#> 1 4-Hydroxybutanoate
#>                                                                                                                                                               id
#> 1 https://envipath.org/package/32de3cf4-e3e6-4168-956e-32fa5ddb0ce1/compound/a41e6b76-b462-49d4-ae42-391ef00bf98c/structure/befe8eeb-e8f8-4b4a-90b1-d0584a75f8cb
#>            smiles
#> 1 C(CC(=O)[O-])CO
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$references
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$references$rheaReferences
#> list()
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$references$uniprotCount
#> list()
#> 
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$reviewStatus
#> [1] "reviewed"
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$scenarios
#> list()
#> 
#> $`2b6bbcc5-77f4-4bed-92a9-731cdc978f6a`$smirks
#> [1] "C(CCO)C=O>>C(CC(=O)[O-])CO"
#> 
#> attr(,"call")
#> [1] "https://envipath.org/api/legacy/package/32de3cf4-e3e6-4168-956e-32fa5ddb0ce1/reaction/2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#> 
#> attr(,"call")
#> attr(,"call")$url
#> [1] "https://envipath.org/api/legacy/package/32de3cf4-e3e6-4168-956e-32fa5ddb0ce1/reaction/2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"
#> 
```
