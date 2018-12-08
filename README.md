# Fiscaly

Financial date class for ruby.

## Dependencies

* ruby 2.3+
* activesupport 5.0+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fiscaly'
```

Then execute:

    $ bundle

## Usage

Create from date:

```ruby
Fiscaly.ymd(2017, 1, 1)
Fiscaly.date(Date.new(2017, 1, 1))
Fiscaly.parse("2017-01-01")
```

Create from date having financial year:

```ruby
Fiscaly.fymd(2017, 1, 1)
Fiscaly.fdate(Date.new(2017, 1, 1))
Fiscaly.fparse("2017-01-01")
```

Change the start month of financial year:

```ruby
# set globally
Fiscaly.start_month = 4

# set locally
Fiscaly.date(date, start_month: 4)
```

Get range of financial calendar:

```ruby
fiscal = Fiscaly.ymd(2017, 1, 1)

fiscal.beginning_of_fyear
#=> 2016-04-01
fiscal.end_of_fyear
#=> 2017-03-31
fiscal.range_of_fyear
#=> 2016-04-01..2017-03-31

fiscal.beginning_of_fhalf
#=> 2016-10-01
fiscal.end_of_fhalf
#=> 2017-03-31
fiscal.range_of_fhalf
#=> 2016-10-01..2017-03-31

fiscal.beginning_of_fhalf(0)
#=> 2016-04-01
fiscal.end_of_fhalf(0)
#=> 2016-09-30
fiscal.range_of_fhalf(0)
#=> 2016-04-01..2016-09-30

fiscal.beginning_of_fquarter
#=> 2017-01-01
fiscal.end_of_fquarter
#=> 2017-03-31
fiscal.range_of_fquarter
#=> 2017-01-01..2017-03-31

fiscal.beginning_of_fquarter(0)
#=> 2016-04-01
fiscal.end_of_fquarter(0)
#=> 2017-03-31
fiscal.range_of_fquarter(0)
#=> 2016-04-01..2017-03-31
```

Extend ruby's standard `Date` class:

```ruby
require 'fiscaly/extension'

date = Date.today.fiscaly
date.fyear
```

## Contributing

Bug reports and pull requests are welcome at https://github.com/kanety/fiscaly.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
