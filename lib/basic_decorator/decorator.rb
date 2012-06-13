module BasicDecorator
  unless defined?(::BasicObject)
    class ::BasicObject
      instance_methods.each do |m|
        undef_method(m) if m.to_s !~ /(?:^__|^==$)/
      end
    end
  end

  class Decorator < ::BasicObject
    undef_method :==

    def initialize(component)
      @component = component
    end

    def method_missing(name, *args, &block)
      @component.send(name, *args, &block)
    end

    def send(symbol, *args)
      __send__(symbol, *args)
    end

    def self.const_missing(name)
      ::Object.const_get name
    end
  end
end
