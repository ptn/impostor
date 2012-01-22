module Impostor
  module Utils
    module StoreProcs
      def store_procs_with(name, opts={})
        plural = opts[:plural] || name.to_s + "s"

        opts[:default] ||= proc { nil }
        hash = Hash.new { opts[:default] }

        metaclass = class << self; self; end

        setter = -> name, &callback { hash[name] = callback }
        metaclass.instance_eval do
          define_method name, &setter
        end

        getter = -> { hash }
        instance_eval do
          define_method plural, &getter
          private plural
        end
      end
    end
  end
end
