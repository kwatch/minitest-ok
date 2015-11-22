# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

require 'minitest'


module Minitest


  module Assertions

    def ok
      actual = yield
      Ok::AssertionObject.new(actual, self, caller(1, 1).first)
    end

  end


  module Ok

    VERSION = '$Release: 0.0.0 $'.split()[1]


    class AssertionObject

      def initialize(actual, context, location)
        @actual  = actual
        @context = context
        @not     = false
        @tested  = tested = [false]
        ObjectSpace.define_finalizer(self, proc {
          unless tested[0]
            loc = location.to_s.split(/:in /).first
            $stderr.puts "** WARNING: ok() called but no assertion invoked (#{loc})"
          end
        })
      end

      def NOT()
        @not = ! @not
        self
      end

      def ==(expected)
        @tested[0] = true
        @context.assert_equal expected, @actual  unless @not
        @context.refute_equal expected, @actual  if     @not
        self
      end

      def !=(expected)
        @tested[0] = true
        @context.refute_equal expected, @actual  unless @not
        @context.assert_equal expected, @actual  if     @not
        self
      end

      def >(expected)
        @tested[0] = true
        @context.assert_operator @actual, :'>', expected  unless @not
        @context.refute_operator @actual, :'>', expected  if     @not
        self
      end

      def >=(expected)
        @tested[0] = true
        @context.assert_operator @actual, :'>=', expected  unless @not
        @context.refute_operator @actual, :'>=', expected  if     @not
        self
      end

      def <(expected)
        @tested[0] = true
        @context.assert_operator @actual, :'<', expected  unless @not
        @context.refute_operator @actual, :'<', expected  if     @not
        self
      end

      def <=(expected)
        @tested[0] = true
        @context.assert_operator @actual, :'<=', expected  unless @not
        @context.refute_operator @actual, :'<=', expected  if     @not
      end

      def =~(expected)
        @tested[0] = true
        @context.assert_match expected, @actual  unless @not
        @context.refute_match expected, @actual  if     @not
        self
      end

      def !~(expected)
        @tested[0] = true
        @context.refute_match expected, @actual  unless @not
        @context.assert_match expected, @actual  if     @not
        self
      end

      def is_a?(expected)
        @tested[0] = true
        @context.assert_kind_of expected, @actual  unless @not
        @context.refute_kind_of expected, @actual  if     @not
        self
      end

      alias kind_of? is_a?

      def instance_of?(expected)
        @tested[0] = true
        @context.assert_instance_of expected, @actual  unless @not
        @context.refute_instance_of expected, @actual  if     @not
        self
      end

      def same?(expected)
        @tested[0] = true
        @context.assert_same expected, @actual  unless @not
        @context.refute_same expected, @actual  if     @not
        self
      end

      def empty?
        @tested[0] = true
        @context.assert_empty @actual  unless @not
        @context.refute_empty @actual  if     @not
        self
      end

      def in_delta?(expected, delta)
        @tested[0] = true
        @context.assert_in_delta(expected, @actual, delta)  unless @not
        @context.refute_in_delta(expected, @actual, delta)  if     @not
        self
      end

      def in_epsilon?(expected, epsilon)
        @tested[0] = true
        @context.assert_in_epsilon(expected, @actual, epsilon)  unless @not
        @context.refute_in_epsilon(expected, @actual, epsilon)  if     @not
        self
      end

      def raise?(exception_class, message=nil)
        @tested[0] = true
        ! @not  or
          raise "NOT.raise? is unsupported because refute_raises() is not defined in Minitest."
        ex = @context.assert_raises(exception_class) { @actual.call }
        @actual.instance_variable_set('@exception', ex)
        class << @actual
          attr_reader :exception
        end
        if message.is_a?(Regexp)
          @context.assert_match message, ex.message
        elsif message
          @context.assert_equal message, ex.message
        end
        self
      end

      def throw?(sym)
        @tested[0] = true
        ! @not  or
          raise "NOT.throw? is unsupported because refute_throws() is not defined in Minitest."
        @context.assert_throws(sym) { @actual.call }
        self
      end

      def respond_to?(expected)
        @tested[0] = true
        @context.assert_respond_to @actual, expected  unless @not
        @context.refute_respond_to @actual, expected  if     @not
        self
      end

      def include?(expected)
        @tested[0] = true
        @context.assert_includes @actual, expected  unless @not
        @context.refute_includes @actual, expected  if     @not
        self
      end

      def output?(stdout=nil, stderr=nil)
        @tested[0] = true
        ! @not  or
          raise "use ok().silent? instead of ok().NOT.output?."
        @context.assert_output(stdout, stderr, &@actual)
        self
      end

      def silent?
        @tested[0] = true
        ! @not  or
          raise "use ok().output? instead of ok().NOT.silent?."
        @context.assert_silent(&@actual)
        self
      end

      ## for predicates

      def frozen?
        @tested[0] = true
        @context.assert_predicate @actual, :frozen?  unless @not
        @context.refute_predicate @actual, :frozen?  if     @not
        self
      end

      def tainted?
        @tested[0] = true
        @context.assert_predicate @actual, :tainted?  unless @not
        @context.refute_predicate @actual, :tainted?  if     @not
        self
      end

      def instance_variable_defined?(varname)
        @tested[0] = true
        result = @actual.instance_variable_defined?(varname)
        unless @not
          @context.assert result, "Expected #{@actual.inspect} to have instance variable #{varname}, but not."
        else
          @context.refute result, "Expected #{@actual.inspect} not to have instance variable #{varname}, but has it."
        end
        self
      end

      def method_missing(symbol, *args, &block)
        unless symbol.to_s =~ /\?\z/
          return super
        end
        @tested[0] = true
        result = @actual.__send__(symbol, *args, &block)
        unless @not
          @context.assert result, proc { "Expected #{@actual.inspect}.#{symbol}(#{args.inspect[1..-2]}) but failed." }
        else
          @context.refute result, proc { "Expected #{@actual.inspect}.#{symbol}(#{args.inspect[1..-2]}) to fail but succeeded." }
        end
        self
      end

      ## other helpers

      def truthy?
        @tested[0] = true
        unless @not
          @context.assert @actual, proc { "Expected (!! #{@actual.inspect}) == true, but not."  }
        else
          @context.refute @actual, proc { "Expected (!! #{@actual.inspect}) == false, but not." }
        end
        self
      end

      def falthy?
        @tested[0] = true
        unless @not
          @context.refute @actual, proc { "Expected (!! #{@actual.inspect}) == false, but not." }
        else
          @context.assert @actual, proc { "Expected (!! #{@actual.inspect}) == true, but not."  }
        end
        self
      end

    end


  end


end
