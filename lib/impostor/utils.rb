module Impostor
  module Utils
    module StoreProcs
      #
      # A macro that defines a macro for storing blocks.
      #
      # This method takes a symbol and defines:
      #
      # * a class method with that name that stores blocks in a hash
      #
      # * a private instance method with the name pluralized for accessing said
      # hash
      #
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
