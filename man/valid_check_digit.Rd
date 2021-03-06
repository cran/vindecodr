% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/valid_check_digit.R
\name{valid_check_digit}
\alias{valid_check_digit}
\title{Check for Valid VIN Check Digit}
\usage{
valid_check_digit(vin, value = FALSE, guess = FALSE)
}
\arguments{
\item{vin}{character. The VIN to check. VINs must be compete, i.e. 17 digits
with no wildcards.}

\item{value}{logical. Should the calculated check digit be returned instead?}

\item{guess}{logical. Should incorrect characters be replaced by the best
guess at corrected characters?
O -> 0
I -> 1
Q -> 0}
}
\value{
If \code{value} is \code{FALSE}, a logical value is returned.
If \code{value} is \code{TRUE}, a character is returned.
}
\description{
Calculates the VIN check digit and compares it to VIN position 9.
For US-based VINs, this determines if the VIN is valid.
This may not apply to VINs from outside of the United States.
}
\examples{
valid_check_digit("WDBEA30D3HA391172") # True
valid_check_digit("WDBEA30D3HA391172", value = TRUE)
valid_check_digit("WDBEA3QD3HA39I172", guess = TRUE)
}
