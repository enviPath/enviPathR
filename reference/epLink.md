# Link enviPath objects

epLink returns mappings between enviPath object types.

## Usage

``` r
epLink(from, to, init = NULL, pkg = NULL, BPPARAM = bpparam(), rate = 5)
```

## Arguments

- from:

  `Character scalar`. String specifying the object type from which
  mapping is performed.

- to:

  `Character scalar`. String specifying the object type to which mapping
  is performed.

- init:

  `Character vector`. Vector of strings specifying the initial values of
  `from` that should be mapped to `to`. When null, all objects belonging
  to `from` in `pkg` are used. (Default: `NULL`)

- pkg:

  `Character scalar`. String specifying the unique identifier of the
  package from which objects should be mapped When null, EAWAG-BBD is
  used. (Default: `NULL`)

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

A data frame with links between from and to.

## Details

For transparency, the performed raw API calls can be accessed with
`attr(x, "call")`, where `x` is the output of `epLink`.

## Examples

``` r
if( is_active ){
# Perform login with your credentials
epLogin(username, password)

# Define custom reaction identifier
rxn_id <- "2b6bbcc5-77f4-4bed-92a9-731cdc978f6a"

# Link custom reaction to related compounds
epLink("reaction", "compound", rxn_id)
}
#> Hi nature lover, welcome to enviPath!
#>                               reaction                             compound
#> 1 2b6bbcc5-77f4-4bed-92a9-731cdc978f6a 7281d994-9f4a-4f7f-9e50-90b131c11da3
#> 2 2b6bbcc5-77f4-4bed-92a9-731cdc978f6a befe8eeb-e8f8-4b4a-90b1-d0584a75f8cb
```
