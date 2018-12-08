require 'active_support/core_ext/integer'
require 'active_support/core_ext/time'
require 'fiscaly/version'

class Fiscaly
  KEY = :fiscaly_start_month

  cattr_accessor :start_month
  @@start_month = 4

  attr_reader :date
  attr_reader :start_month

  def initialize(date, start_month: nil)
    @start_month = start_month || self.class.global_start_month
    @date = date
  end

  def method_missing(name, *args)
    if @date.respond_to?(name)
      @date.send(name, *args)
    else
      super
    end
  end

  def fyear
    if @date.month >= @start_month
      @date.year
    else
      @date.year - 1
    end
  end

  def fdate
    Date.new(fyear, @date.month, @date.day);
  end

  def beginning_of_fyear
    Date.new(fyear, @start_month)
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
      date += 6.months until @date <= date
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
      date += 3.months until @date <= date
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

    def fdate(date, options = {})
      self.new(normalize(date, options[:start_month]), options)
    end

    def fparse(str, options = {})
      fdate(Date.parse(str), options)
    end

    def fymd(fyear, month = 1, day = 1, options = {})
      fdate(Date.new(fyear, month, day), options)
    end

    def with_start_month(start_month)
      Thread.current[KEY] = start_month
      yield
    ensure
      Thread.current[KEY] = nil
    end

    def global_start_month
      Thread.current[KEY] || self.start_month
    end

    private

    def normalize(date, start_month)
      start_month ||= global_start_month
      if date.month < start_month
        Date.new(date.year + 1, date.month, date.day)
      else
        date
      end
    end
  end
end
