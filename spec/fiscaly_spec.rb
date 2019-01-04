describe Fiscaly do
  before {
    Fiscaly.start_month = 4
    Fiscaly.forward_fyear = false
  }

  it 'has a version number' do
    expect(Fiscaly::VERSION).not_to be nil
  end

  it 'is created from normal date' do
    fiscals = [
      Fiscaly.date(Date.new(2017, 3)),
      Fiscaly.parse("2017-03-01"),
      Fiscaly.ymd(2017, 3)
    ]
    fiscals.each do |fiscal|
      expect(fiscal.fyear).to eq(2016)
    end

    fiscals = [
      Fiscaly.date(Date.new(2017, 4)),
      Fiscaly.parse("2017-04-01"),
      Fiscaly.ymd(2017, 4)
    ]
    fiscals.each do |fiscal|
      expect(fiscal.fyear).to eq(2017)
    end
  end

  it 'is created from date with financial year' do
    fiscals = [
      Fiscaly.fdate(Date.new(2017, 3, 1)),
      Fiscaly.fparse("2017-03-01"),
      Fiscaly.fymd(2017, 3, 1)
    ]
    fiscals.each do |fiscal|
      expect(fiscal.year).to eq(2018)
    end

    fiscals = [
      Fiscaly.fdate(Date.new(2017, 4, 1)),
      Fiscaly.fparse("2017-04-01"),
      Fiscaly.fymd(2017, 4, 1)
    ]
    fiscals.each do |fiscal|
      expect(fiscal.year).to eq(2017)
    end
  end

  it 'is created from leap date' do
    fiscals = [
      Fiscaly.fparse("2019-02-29"),
      Fiscaly.fymd(2019, 2, 29)
    ]
    fiscals.each do |fiscal|
      expect(fiscal.year).to eq(2020)
    end
  end

  it 'has today' do
    expect(Fiscaly.today.date).to eq(Date.today)
  end

  it 'has financial date method' do
    fiscal = Fiscaly.ymd(2017, 3, 10)

    expect(fiscal.fdate).to eq(Date.new(2016, 3, 10))
    expect(fiscal.fyear).to eq(2016)
  end

  it 'has range of financial year' do
    fiscals = [
      Fiscaly.ymd(2016, 4, 1),
      Fiscaly.ymd(2017, 3, 31)
    ]

    first = Date.new(2016, 4, 1)
    last = Date.new(2017, 3, 31)
    fiscals.each do |fiscal|
      expect(fiscal.beginning_of_fyear).to eq(first)
      expect(fiscal.end_of_fyear).to eq(last)
      expect(fiscal.range_of_fyear).to eq(first..last)
    end
  end

  it 'has range of financial half-year' do
    fiscals = [
      Fiscaly.ymd(2016, 10, 1),
      Fiscaly.ymd(2017, 3, 31)
    ]

    first = Date.new(2016, 10, 1)
    last = Date.new(2017, 3, 31)
    fiscals.each do |fiscal|
      expect(fiscal.beginning_of_fhalf).to eq(first)
      expect(fiscal.end_of_fhalf).to eq(last)
      expect(fiscal.range_of_fhalf).to eq(first..last)
    end
  end

  it 'has range of financial half-year(0)' do
    fiscal = Fiscaly.ymd(2017, 3)

    first = Date.new(2016, 4, 1)
    last = Date.new(2016, 9, 30)
    expect(fiscal.beginning_of_fhalf(0)).to eq(first)
    expect(fiscal.end_of_fhalf(0)).to eq(last)
    expect(fiscal.range_of_fhalf(0)).to eq(first..last)
  end

  it 'has range of financial quarter' do
    fiscals = [
      Fiscaly.ymd(2017, 1, 1),
      Fiscaly.ymd(2017, 3, 31)
    ]

    first = Date.new(2017, 1, 1)
    last = Date.new(2017, 3, 31)
    fiscals.each do |fiscal|
      expect(fiscal.beginning_of_fquarter).to eq(first)
      expect(fiscal.end_of_fquarter).to eq(last)
      expect(fiscal.range_of_fquarter).to eq(first..last)
    end
  end

  it 'has range of financial quarter(0)' do
    fiscal = Fiscaly.ymd(2017, 3)

    first = Date.new(2016, 4, 1)
    last = Date.new(2016, 6, 30)
    expect(fiscal.beginning_of_fquarter(0)).to eq(first)
    expect(fiscal.end_of_fquarter(0)).to eq(last)
    expect(fiscal.range_of_fquarter(0)).to eq(first..last)
  end

  it 'has range of month' do
    fiscals = [
      Fiscaly.ymd(2017, 3, 1),
      Fiscaly.ymd(2017, 3, 31)
    ]

    first = Date.new(2017, 3, 1)
    last = Date.new(2017, 3, 31)
    fiscals.each do |fiscal|
      expect(fiscal.beginning_of_month).to eq(first)
      expect(fiscal.end_of_month).to eq(last)
      expect(fiscal.range_of_month).to eq(first..last)
    end
  end

  it 'has date methods' do
    fiscal = Fiscaly.ymd(2017, 3, 10)

    expect(fiscal.year).to eq(2017)
    expect(fiscal.month).to eq(3)
    expect(fiscal.day).to eq(10)
  end

  it 'sets start month by argument' do
    expect(Fiscaly.ymd(2017, 2, 1, start_month: 3).fyear).to eq(2016)
    expect(Fiscaly.ymd(2017, 3, 1, start_month: 3).fyear).to eq(2017)
  end

  it 'sets start month by block' do
    Fiscaly.with(start_month: 3) do
      expect(Fiscaly.ymd(2017, 2, 1).fyear).to eq(2016)
      expect(Fiscaly.ymd(2017, 3, 1).fyear).to eq(2017)
      Fiscaly.with(start_month: 4) do
        expect(Fiscaly.ymd(2017, 3, 1).fyear).to eq(2016)
        expect(Fiscaly.ymd(2017, 4, 1).fyear).to eq(2017)
      end
      expect(Fiscaly.ymd(2017, 2, 1).fyear).to eq(2016)
      expect(Fiscaly.ymd(2017, 3, 1).fyear).to eq(2017)
    end
  end

  it 'sets forward fyear by argument' do
    fiscal = Fiscaly.ymd(2017, 3, 1, forward_fyear: true)
    expect(fiscal.fyear).to eq(2017)
    expect(fiscal.beginning_of_fyear).to eq(Date.new(2016, 4, 1))

    fiscal = Fiscaly.ymd(2017, 4, 1, forward_fyear: true)
    expect(fiscal.fyear).to eq(2018)
    expect(fiscal.beginning_of_fyear).to eq(Date.new(2017, 4, 1))
  end

  it 'sets forward fyear by block' do
    Fiscaly.with(forward_fyear: true) do
      expect(Fiscaly.ymd(2017, 3, 1).fyear).to eq(2017)
      expect(Fiscaly.ymd(2017, 4, 1).fyear).to eq(2018)
      Fiscaly.with(forward_fyear: false) do
        expect(Fiscaly.ymd(2017, 3, 1).fyear).to eq(2016)
        expect(Fiscaly.ymd(2017, 4, 1).fyear).to eq(2017)
      end
      expect(Fiscaly.ymd(2017, 3, 1).fyear).to eq(2017)
      expect(Fiscaly.ymd(2017, 4, 1).fyear).to eq(2018)
    end
  end

  it 'raises error for undefined method' do
    fiscal = Fiscaly.today
    expect { fiscal.some_unknown_method }.to raise_error(NoMethodError)
  end
end
