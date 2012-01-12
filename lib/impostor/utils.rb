module Impostor
  module Utils
    module LazyEval
      def lazy_eval(name, opts={})
        plural = opts[:plural] || name.to_s + "s"
        hash = Hash.new &opts[:default]

        meta = class << self; self; end

        getter = -> { hash }
        meta.instance_eval do
          define_method plural, &getter
        end

        setter = -> name, &callback { hash[name] = callback }
        meta.instance_eval do
          define_method name, &setter
        end
      end
    end
  end
end
