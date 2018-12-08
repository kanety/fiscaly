require 'fiscaly/extension'

describe Fiscaly::Extension do
  it 'extends Date class' do
    expect(Date.today.fiscaly).to be_kind_of(Fiscaly)
  end
end
