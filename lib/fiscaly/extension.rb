class Fiscaly
  module Extension
    def fiscaly(options = {})
      Fiscaly.new(self, options)
    end
  end
end

Date.send(:include, Fiscaly::Extension)
