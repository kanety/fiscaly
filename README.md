# Fiscaly

Fiscal date class for ruby.

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

Configure fiscal year:

```ruby
# set the start month of the fiscal year
Fiscaly.start_month = 4

# set true if the fiscal year is based on the following year
Fiscaly.forward_fyear = false
```

Create from calendar year:

```ruby
fiscal = Fiscaly.ymd(2017, 1, 1)
fiscal.date
#=> 2017-01-01

fiscal = Fiscaly.date(Date.new(2017, 1, 1))
fiscal.date
#=> 2017-01-01

fiscal = Fiscaly.parse("2017-01-01")
fiscal.date
#=> 2017-01-01
```

If you want to create from fiscal year, following methods are available:

```ruby
fiscal = Fiscaly.fymd(2017, 1, 1)
fiscal.date
#=> 2018-01-01

fiscal = Fiscaly.fdate(Date.new(2017, 1, 1))
fiscal.date
#=> 2018-01-01

fiscal = Fiscaly.fparse("2017-01-01")
fiscal.date
#=> 2018-01-01
```

Note that these methods converts the fiscal year to the calendar year but the month and the day are kept as it is.

Get the range of financial calendar:

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
#=> 2016-06-30
fiscal.range_of_fquarter(0)
#=> 2016-04-01..2016-06-30
```

Change the configurations in some context:

```ruby
# set by argument
fiscal = Fiscaly.ymd(2017, 10, 1, start_month: 10, forward_fyear: true)
fiscal.fyear  #=> 2018

# set by block
Fiscaly.with(start_month: 10, forward_fyear: true) do
  fiscal = Fiscaly.ymd(2017, 10, 1)
  fiscal.fyear  #=> 2018
end
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
