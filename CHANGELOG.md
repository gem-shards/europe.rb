# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

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
