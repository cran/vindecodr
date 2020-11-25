
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vindecodr ![vindecodr](man/figures/sticker-small.png)

<!-- badges: start -->

[![CRAN status
badge](https://www.r-pkg.org/badges/version/vindecodr)](https://cran.r-project.org/package=vindecodr)
[![Travis build
status](https://travis-ci.com/burch-cm/vindecodr.svg?branch=main)](https://travis-ci.com/burch-cm/vindecodr)
<!-- badges: end -->

The goal of vindecodr (pronounced “VIN decoder”) is to provide an
efficient programmatic interface to the US Department of Transportation
(DOT) National Highway Transportation Safety Administration (NHTSA)
vehicle identification number (VIN) decoder API, located at
<https://vpic.nhtsa.dot.gov/api/>.

## Installation

You can install the released version of vindecodr from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("vindecodr")
```

Or you can install the development version from
[GitHub](https://github.com/burch-cm/vindecodr) with:

``` r
# install.packages("devtools")
devtools::install_github("burch-cm/vindecodr")
```

## Loading

Load the library in R by calling `library()`:

``` r
library(vindecodr)
```

## Examples

### Check the VIN for Errors:

VINs must be 17 digits long and cannot contain certain characters (I, O
Q). In addition, vehicles sold in North America have a “check digit” in
position 9 of the VIN. This check digit must equal the result of a
calculation applied to the other VIN digits for the VIN to be considered
valid.

{vindecodr} contains tools to validate the length, characters, and check
digit of a given VIN or VINs, and to guess at any disallowed characters,
which often creep into VIN records when recorded by hand.

The main function to check a number of VINs is `check_vin()`, which
takes a character vector of VINs to check. If `{purrr}` is present,
`check_vin()` will try to use it, otherwise a less-efficient loop will
be used to iterate over the VINs.

``` r
vins <- c("WDBEA30D3HA391172", "3VWLL7AJ9BM053541")
check_vin(vins)
#> [1] TRUE TRUE
```

`check_vin()` looks at the length of the VINs, checks for disallowed
characters (and attempts to correct them with guess = TRUE), and
compares the result of the VIN check digit calculation with the digit in
the check digit position of the VIN (the 9th position).

To check just the length and disallowed characters, use
`valid_vin_format()`

``` r
valid_vin_format("WDBEA30D3HA391172")
#> [1] TRUE
```

To check the validity of the check digit, use `valid_check_digit()`

``` r
valid_check_digit("WDBEA30D3HA391172")
#> [1] TRUE
```

This can also return the check digit itself:

``` r
valid_check_digit("WDBEA30D3HA391172", value = TRUE)
#> [1] "3"
```

### Find the Make and Model for a Given VIN:

Managed fleet vehicle systems often need to confirm the information they
have on file for a particular vehicle, such as the make, model, fuel
type, etc. This can easily be accomplished by comparing the records on
file with the manufacturer’s values as encoded in the VIN.

``` r

given_vin <- "1C4BJWFGXDL531773"

vehicle_details <- decode_vin(given_vin)

knitr::kable(vehicle_details)
```

| VIN               | make | model    | model\_year | fuel\_type | GVWR                                          |
| :---------------- | :--- | :------- | :---------- | :--------- | :-------------------------------------------- |
| 1C4BJWFGXDL531773 | JEEP | Wrangler | 2013        | Gasoline   | Class 1D: 5,001 - 6,000 lb (2,268 - 2,722 kg) |

Single VINs are passed to the [Decode API
Endpoint](https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINValues/).  
The same call can be used for up to 50 VINs. When multiple VINs are
provided, the [Batch API
Endpoint](https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINBatchValues/)
is used instead.

``` r
library(vindecodr)

given_vins <- c("1C4BJWFGXDL531773",
                "JTHFF2C26B2515141",
                "WDBRF40J43F433102")

vehicle_details <- decode_vin(given_vins)
knitr::kable(vehicle_details[1:3])
```

| VIN               | make          | model    |
| :---------------- | :------------ | :------- |
| 1C4BJWFGXDL531773 | JEEP          | Wrangler |
| JTHFF2C26B2515141 | LEXUS         | IS       |
| WDBRF40J43F433102 | MERCEDES-BENZ | C-Class  |

See the [NHTSA API Documentation](https://vpic.nhtsa.dot.gov/api) for
more detail on API endpoints.
