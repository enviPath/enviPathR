# Log into enviPath account

epLogin and epLogout let you log in and out of enviPath, respectively.
An account is required to use the enviPath API.

## Usage

``` r
epLogin(username, password)

epLogout()
```

## Arguments

- username:

  `Character scalar`. String specifying the username used to log into an
  enviPath personal account.

- password:

  `Character scalar`. String specifying the password used to log into an
  enviPath personal account.

## Value

A message upon successful login or logout.

## Examples

``` r
if( is_active ){
# Perform login with your credentials
epLogin(username, password)

# Perform logout
epLogout()
}
#> Hi nature lover, welcome to enviPath!
#> Logged out successfully.
```
