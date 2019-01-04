require 'active_support/core_ext/integer'
require 'active_support/core_ext/time'
require 'fiscaly/version'

class Fiscaly
  KEY = :fiscaly_options

  cattr_accessor :options
  @@options = {
    start_month: 4,
    forward_fyear: false
  }

  attr_reader :date
  attr_reader :options

  def initialize(date, options = {})
    @options = self.class.global_options.merge(options)
    @date = date
  end

  def method_missing(name, *args)
    if @date.respond_to?(name)
      @date.send(name, *args)
    else
      super
    end
  end

  def start_month
    @options[:start_month]
  end

  def forward_fyear?
    @options[:forward_fyear]
  end

  def fyear
    fy = @date.year
    fy -= 1 if @date.month < start_month
    fy += 1 if forward_fyear?
    fy
  end

  def fdate
    Date.new(fyear, @date.month, @date.day);
  end

  def beginning_of_fyear
    year = forward_fyear? ? fyear - 1 : fyear
    Date.new(year, start_month)
  end

  def end_of_fyear
    (beginning_of_fyear + 11.months).end_of_month
  end

  def range_of_fyear
    beginning_of_fyear..end_of_fyear
  end

  def beginning_of_fhalf(index = nil)
    if index
      beginning_of_fyear + (index * 6).months
    else
      date = beginning_of_fyear
      date += 6.months until @date < date
      date -= 6.months
    end
  end

  def end_of_fhalf(index = nil)
    (beginning_of_fhalf(index) + 5.months).end_of_month
  end

  def range_of_fhalf(index = nil)
    beginning_of_fhalf(index)..end_of_fhalf(index)
  end

  def beginning_of_fquarter(index = nil)
    if index
      beginning_of_fyear + (index * 3).months
    else
      date = beginning_of_fyear
      date += 3.months until @date < date
      date -= 3.months
    end
  end

  def end_of_fquarter(index = nil)
    (beginning_of_fquarter(index) + 2.months).end_of_month
  end

  def range_of_fquarter(index = nil)
    beginning_of_fquarter(index)..end_of_fquarter(index)
  end

  def range_of_month
    @date.beginning_of_month..@date.end_of_month
  end

  private

  class << self
    def today(options = {})
      date(Date.today, options)
    end

    def date(date, options = {})
      self.new(date, options)
    end

    def parse(str, options = {})
      date(Date.parse(str), options)
    end

    def ymd(year, month = 1, day = 1, options = {})
      date(Date.new(year, month, day), options)
    end

    def fdate(fdate, options = {})
      fymd(fdate.year, fdate.month, fdate.day, options)
    end

    def fparse(fstr, options = {})
      parsed = Date._parse(fstr)
      fymd(parsed[:year], parsed[:mon], parsed[:mday], options)
    end

    def fymd(fyear, month = 1, day = 1, options = {})
      self.new(normalize(fyear, month, day, options), options)
    end

    def with(options = {})
      Thread.current[KEY] ||= []
      Thread.current[KEY].push(options)
      yield
    ensure
      Thread.current[KEY].pop
      Thread.current[KEY] = nil if Thread.current[KEY].empty?
    end

    def global_options
      @@options.merge((Thread.current[KEY].is_a?(Array) && Thread.current[KEY][-1]) || {})
    end

    def start_month=(val)
      @@options[:start_month] = val
    end

    def forward_fyear=(val)
      @@options[:forward_fyear] = val
    end

    private

    def normalize(fyear, month, day, options = {})
      options = global_options.merge(options)
      year = fyear
      year += 1 if month < options[:start_month]
      year -= 1 if options[:forward_fyear]
      Date.new(year, month, day)
    end
  end
end
