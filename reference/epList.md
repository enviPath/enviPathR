# List enviPath objects

epList returns a list with info on objects available in enviPath.

## Usage

``` r
epList(type, pkg = NULL)
```

## Arguments

- type:

  `Character scalar`. String specifying the object type to listed.

- pkg:

  `Character scalar`. String specifying the unique identifier of the
  package from which objects should be listed. When null, all available
  packages are used. (Default: `NULL`)

## Value

A data frame with all objects belonging to `type` in `pkg`.

## Details

For transparency, the performed raw API call can be accessed with
`attr(x, "call")`, where `x` is the output of `epList`.

## Examples

``` r
if( is_active ){
# Perform login with your credentials
epLogin(username, password)

# List packages
pkg_df <- epList("package")

# Select reviewed packages
to_keep <- pkg_df$reviewStatus == "reviewed"
pkg_df <- pkg_df[to_keep, ]

# Remove lengthy description
pkg_df$description <- NULL

# View some packages
head(pkg_df)

# Select desired package
pkg_name <- "EAWAG-BBD"
pkg_id <- pkg_df$id[pkg_df$name == pkg_name]

# List pathways from desired package
path_df <- epList("pathway", pkg = pkg_id)

# View some pathways
head(path_df)
}
#> Hi nature lover, welcome to enviPath!
#>                      name                                   id reviewStatus
#> 1                 Uranium 259b990e-d653-4201-9282-04f2c6b05ca0     reviewed
#> 2 2-Aminobenzenesulfonate 1e7066c2-ff45-44f4-9086-e37db18400df     reviewed
#> 3                Nicotine 1e94c7d7-7f3a-42c7-9dd0-eb1ab217d7ec     reviewed
#> 4         2-Aminobenzoate dfc8c935-9d73-4067-bfe6-db3501d2075f     reviewed
#> 5                Caffeine 1d537657-298c-496b-9e6f-2bec0cbe0678     reviewed
#> 6    Dimethylisophthalate a0641e14-3811-482f-a366-cc53f893fce4     reviewed
```
