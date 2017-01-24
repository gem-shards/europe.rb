![Europe gem logo](https://s3-eu-west-1.amazonaws.com/valorsis.s3-website-eu-west-1.amazonaws.com/static/logo256.png)
# Europe

This gem provides EU governmental data, extracted from various EU / EC websites. With this gem you can validate VAT numbers, retrieve VAT tax rates and currency exchange rates matched to the Euro. How to use this gem is pretty straightforward and written below.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
  - [Validating VAT numbers](#validating-vat-numbers)
  - [Validate VAT number format](#validate-vat-number-format)
  - [Retrieving VAT rates for each EC/EU member](#retrieving-vat-rates-for-each-eceu-member)
  - [Retrieving currency exchange rates](#retrieving-currency-exchange-rates)
  - [Retrieving currency information](#retrieving-currency-information)
  - [Retrieving country information](#retrieving-country-information)
  - [Retrieving country information reversed](#retrieving-country-information-reversed)
- [Compatibility](#compatibility)
- [Todo](#todo)
- [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'europe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install europe

## Usage

There are several calls you can make with this gem. Below are a few examples
where this gem can be used for.

### Validating VAT numbers
** Updated: Parameter now consists of one value.**
Call to validate VAT number (always starts with country code as specified in VIES)
```ruby
Europe::Vat.validate('GB440627467')
```
Response
```ruby
{ :country_code=>"GB",
  :vat_number=>"440627467",
  :request_date=>#<Date: 2015-12-15 ((2457372j,0s,0n),+0s,2299161j)>,
  :valid=>true,
  :name=>"SKY PLC",
  :address=>"6 CENTAURS BUSINESS PARK\nGRANT WAY\nISLEWORTH\nMIDDLESEX\n\nTW7 5QD" }
```

### Validate VAT number format
Call
```ruby
Europe::Vat::Format.validate('NL123456789B01')
```
Response
```ruby
=> true
```


### Retrieving VAT rates for each EC/EU member
Call
```ruby
Europe::Vat::Rates.retrieve
```
Response
```ruby
{  :AT=>20.0,
   :BE=>21.0,
   :BG=>20.0,
   :CY=>19.0,
   :CZ=>21.0,
   :DE=>19.0,
   :DK=>25.0,
   # etc...
```

### Retrieving currency exchange rates
Call
```ruby
Europe::Currency::ExchangeRates.retrieve
```
Response
```ruby
{  :date=>#<Date: 2015-12-15 ((2457372j,0s,0n),+0s,2299161j)>,
   :rates=>
   { :USD=>1.099,
     :JPY=>132.97,
     :BGN=>1.9558,
     :CZK=>27.022,
     :DKK=>7.4614,
     :GBP=>0.7252,
     # etc...
```

### Retrieving currency information
Call
```ruby
Europe::Currency::CURRENCIES
```
Response
```ruby
CURRENCIES = {
  EUR: { name: 'Euro', symbol: '€', html: '&euro;' },
  BGN: { name: 'Lev', symbol: 'лв', html: '&#1083;&#1074;' },
  # etc...
```

### Retrieving country information
Call
```ruby
Europe::Countries::COUNTRIES
```
Response
```ruby
{
 :BE=>
  {:name=>"Belgium",
   :source_name=>"Belgique/België",
   :official_name=>"Kingdom of Belgium",
   :tld=>".be",
   :currency=>:EUR,
   :capital=>"Brussels"},
 :BG=>
  {:name=>"Bulgaria",
   :source_name=>"България",
   :official_name=>"Republic of Bulgaria",
   :tld=>".bg",
   :currency=>:BGN,
   :capital=>"Sofia"},
 # etc...
```

## Retrieving country information reversed
Call with optional parameters (name, currency, source_name, official_name, tld, currency and capital)
```ruby
Europe::Countries::Reversed.generate('name')
```
Response
```ruby
{  "Belgium" => :BE,
   "Bulgaria" => :BG,
   "Czech Republic" => :CZ,
   "Denmark" => :DK,
   "Germany" => :DE,
   "Estonia" => :EE,
   # etc...
```

## Compatibility

This gem is tested with the following Ruby versions on Linux and Mac OS X:

- Ruby > 2.2.2

## Todo

- ~~VAT number format validation (http://ec.europa.eu/taxation_customs/vies/faqvies.do#item11)~~
- ~~Add more country information~~
- Eurostat integration (http://ec.europa.eu/eurostat/)
- ..

## Contributing

1. Fork it ( https://github.com/VvanGemert/europe/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
