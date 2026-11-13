# Find available enviPath resources

epTypes retrieves the set of listable and linkable enviPath object types

## Usage

``` r
epTypes()
```

## Value

A list with two elements:

- listable: a character vector of the object types supported by
  [`epList`](https://envipath.github.io/enviPathR/reference/epList.md)

- linkable: a data frame of links between object types supported by
  [`epLink`](https://envipath.github.io/enviPathR/reference/epLink.md)

## Examples

``` r
# Retrieve available resources
types <- epTypes()

# View listable object types
types$listable
#> [1] "compound" "package"  "pathway"  "reaction" "rule"     "setting" 

# View linkable object types
types$linkable
#>        from        to
#> 1  compound  inchikey
#> 2  compound   pathway
#> 3  compound  reaction
#> 4  compound    smiles
#> 5  compound structure
#> 6   pathway  compound
#> 7   pathway      edge
#> 8   pathway      node
#> 9   pathway  reaction
#> 10  pathway structure
#> 11 reaction  compound
#> 12 reaction        ec
#> 13 reaction   pathway
#> 14 reaction      rhea
```
