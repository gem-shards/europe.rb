# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
## 0.0.26
  - Removed spaces by default for VAT number format validations, as per request from tim-vandecasteele
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.25...v0.0.26)
## 0.0.25
  - A fix for Ireland's VAT numbers, https://github.com/gem-shards/europe.rb/pull/5, thank you again tim-vandecasteele
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.24...v0.0.25)
## 0.0.24
  - Changed source for retrieving VAT rates. (https://europa.eu/youreurope/business/taxation/vat/vat-rules-rates/index_en.htm)
  - Removed UK from VAT rate fallbacks
  - Updated VAT rates for Slovakia (SK) and Finland (FI)
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.23...v0.0.24)
## 0.0.23
  - Added support for new Belgium VAT numbers, thank you tim-vandecasteele
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.22...v0.0.23)
## 0.0.22
  - Updated Estonia's tax rate to 22%
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.21...v0.0.22)
## 0.0.21
  - Added check to fail short VAT numbers under 5 characters
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.20...v0.0.21)
## 0.0.20
  - Added fallback VAT rates in case the EU website is down or unresponsive
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.19...v0.0.20)
## 0.0.19
  - Fixed VAT validation call because XML response was updated
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.18...v0.0.19)
## 0.0.18
  - Added Estonia and Lithuania to eurozone
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.17...v0.0.18)
## 0.0.17
  - Removed all UK VAT logic
  - Updated development dependencies
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.16...v0.0.17)
## 0.0.16
  - Changed Slovak Republic to Slovakia in country names
  - Updated outdated endpoint for VAT rates, thanks to @firstpromoter
  - Fixed a couple of rubocop issues
  - [Full Changelog](https://github.com/gem-shards/europe.rb/compare/v0.0.15...v0.0.16)
## 0.0.15
  - Checked library on Ruby 2.7
  - Moved repository to gem-shards
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.14...v0.0.15)

## 0.0.14
  - Fixed rubocop syntax issues
  - Fixed issue with retrieving exchange rates when no valid JSON is returned
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.13...v0.0.14)

## 0.0.13
  - Fixed rubocop syntax issues
  - Changed ExchangeRate source from XML to JSON
  - Fixed date parsing and soap:fault handling in VAT validation
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.12...v0.0.13)

## 0.0.12
  - Fixed extracting vat validation data when it didn't exists
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.11...v0.0.12)

## 0.0.11
  - Removed print outout when fetching VAT rates
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.10...v0.0.11)

## 0.0.10
  - Changed URL for retrieving VAT rates because it was modified and redirected
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.9...v0.0.10)

## 0.0.9
  - Removed all external depdencies, only Ruby's standard library is used
  - Added Postal code format validator
  - Used different source for exchange rates which returns more currencies
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.8...v0.0.9)

## 0.0.8
  - Changed URL for retrieving VAT rates. The old one was no longer valid
  - Skipped Eurostat tests as URL changed. Eurostat use is still expirimental
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.7...v0.0.8)

## 0.0.7
  - Fixed currencies for Estonia, Lithuania and Sweden
  - Added eurozone call to Countries which returns all countries with EUR currency
  - Removed simplecov because of Gem errors
  - Updated dependencies and fixed rubocop syntax errors
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.6...v0.0.7)

## 0.0.6
  - Added Changelog
  - Fixed test case for VAT validation where EU VIES services times out
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.5...v0.0.6)

## 0.0.5
  - Added SimpleCov for Code coverage
  - Added README
  - Added VAT number sanitizer and charge_vat? method
  - Changed requirement of Ruby version to be greater than 2.2.2
  - Disabled warnings in test helper
  - Added minitest-reporters gem for better overview of tests
  - Fixed code syntax with new rubocop version
  - [Full Changelog](https://github.com/VvanGemert/europe/compare/v0.0.4...v0.0.5)
