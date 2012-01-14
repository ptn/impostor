module Impostor
  module Utils
    module StoreProcs
      def store_procs_with(name, opts={})
        plural = opts[:plural] || name.to_s + "s"
        hash = Hash.new &opts[:default]

        metaclass = class << self; self; end

        getter = -> { hash }
        metaclass.instance_eval do
          define_method plural, &getter
        end

        setter = -> name, &callback { hash[name] = callback }
        metaclass.instance_eval do
          define_method name, &setter
        end
      end
    end
  end
end
