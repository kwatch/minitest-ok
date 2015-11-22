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

      def _mark_as_tested   # :nodoc:
        @tested[0] = true
        self
      end

      def NOT()
        @not = ! @not
        self
      end

      def ==(expected)
        _mark_as_tested()
        @context.assert_equal expected, @actual  unless @not
        @context.refute_equal expected, @actual  if     @not
        self
      end

      def !=(expected)
        _mark_as_tested()
        @context.refute_equal expected, @actual  unless @not
        @context.assert_equal expected, @actual  if     @not
        self
      end

      def >(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'>', expected  unless @not
        @context.refute_operator @actual, :'>', expected  if     @not
        self
      end

      def >=(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'>=', expected  unless @not
        @context.refute_operator @actual, :'>=', expected  if     @not
        self
      end

      def <(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'<', expected  unless @not
        @context.refute_operator @actual, :'<', expected  if     @not
        self
      end

      def <=(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'<=', expected  unless @not
        @context.refute_operator @actual, :'<=', expected  if     @not
      end

      def =~(expected)
        _mark_as_tested()
        @context.assert_match expected, @actual  unless @not
        @context.refute_match expected, @actual  if     @not
        self
      end

      def !~(expected)
        _mark_as_tested()
        @context.refute_match expected, @actual  unless @not
        @context.assert_match expected, @actual  if     @not
        self
      end

      def is_a?(expected)
        _mark_as_tested()
        @context.assert_kind_of expected, @actual  unless @not
        @context.refute_kind_of expected, @actual  if     @not
        self
      end

      alias kind_of? is_a?

      def instance_of?(expected)
        _mark_as_tested()
        @context.assert_instance_of expected, @actual  unless @not
        @context.refute_instance_of expected, @actual  if     @not
        self
      end

      def same?(expected)
        _mark_as_tested()
        @context.assert_same expected, @actual  unless @not
        @context.refute_same expected, @actual  if     @not
        self
      end

      def empty?
        _mark_as_tested()
        @context.assert_empty @actual  unless @not
        @context.refute_empty @actual  if     @not
        self
      end

      def in_delta?(expected, delta)
        _mark_as_tested()
        @context.assert_in_delta(expected, @actual, delta)  unless @not
        @context.refute_in_delta(expected, @actual, delta)  if     @not
        self
      end

      def in_epsilon?(expected, epsilon)
        _mark_as_tested()
        @context.assert_in_epsilon(expected, @actual, epsilon)  unless @not
        @context.refute_in_epsilon(expected, @actual, epsilon)  if     @not
        self
      end

      def raise?(exception_class, message=nil)
        _mark_as_tested()
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
        _mark_as_tested()
        ! @not  or
          raise "NOT.throw? is unsupported because refute_throws() is not defined in Minitest."
        @context.assert_throws(sym) { @actual.call }
        self
      end

      def respond_to?(expected)
        _mark_as_tested()
        @context.assert_respond_to @actual, expected  unless @not
        @context.refute_respond_to @actual, expected  if     @not
        self
      end

      def include?(expected)
        _mark_as_tested()
        @context.assert_includes @actual, expected  unless @not
        @context.refute_includes @actual, expected  if     @not
        self
      end

      def output?(stdout=nil, stderr=nil)
        _mark_as_tested()
        ! @not  or
          raise "use ok().silent? instead of ok().NOT.output?."
        @context.assert_output(stdout, stderr, &@actual)
        self
      end

      def silent?
        _mark_as_tested()
        ! @not  or
          raise "use ok().output? instead of ok().NOT.silent?."
        @context.assert_silent(&@actual)
        self
      end

      ## for predicates

      def frozen?
        _mark_as_tested()
        @context.assert_predicate @actual, :frozen?  unless @not
        @context.refute_predicate @actual, :frozen?  if     @not
        self
      end

      def tainted?
        _mark_as_tested()
        @context.assert_predicate @actual, :tainted?  unless @not
        @context.refute_predicate @actual, :tainted?  if     @not
        self
      end

      def instance_variable_defined?(varname)
        _mark_as_tested()
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
        _mark_as_tested()
        unless @not
          ## Try assert_xxxx() at first.
          ## If not defined, try assert @actual.xxxx?.
          begin
            @context.__send__("assert_#{symbol.to_s[0..-2]}", @actual, *args, &block)
          rescue NoMethodError
            result = @actual.__send__(symbol, *args, &block)
            @context.assert result, proc { "Expected #{@actual.inspect}.#{symbol}(#{args.inspect[1..-2]}) but failed." }
          end
        else
          ## Try refute_xxxx() at first.
          ## If not defined, try refute @actual.xxxx?.
          begin
            @context.__send__("refute_#{symbol.to_s[0..-2]}", @actual, *args, &block)
          rescue NoMethodError
            result = @actual.__send__(symbol, *args, &block)
            @context.refute result, proc { "Expected #{@actual.inspect}.#{symbol}(#{args.inspect[1..-2]}) to fail but succeeded." }
          end
        end
        self
      end

      ## other helpers

      def truthy?
        _mark_as_tested()
        unless @not
          @context.assert @actual, proc { "Expected (!! #{@actual.inspect}) == true, but not."  }
        else
          @context.refute @actual, proc { "Expected (!! #{@actual.inspect}) == false, but not." }
        end
        self
      end

      def falthy?
        _mark_as_tested()
        unless @not
          @context.refute @actual, proc { "Expected (!! #{@actual.inspect}) == false, but not." }
        else
          @context.assert @actual, proc { "Expected (!! #{@actual.inspect}) == true, but not."  }
        end
        self
      end

      def file_exist?
        _mark_as_tested()
        fpath = @actual
        unless @not
          @context.assert File.exist?(fpath), "File '#{fpath}' doesn't exist."
          @context.assert File.file?(fpath),  "'#{fpath}' is not a file."
        else
          @context.refute File.exist?(fpath), "File '#{fpath}' exists unexpectedly."
        end
      end

      def dir_exist?
        _mark_as_tested()
        fpath = @actual
        unless @not
          @context.assert File.exist?(fpath),     "Directory '#{fpath}' doesn't exist."
          @context.assert File.directory?(fpath), "'#{fpath}' is not a directory."
        else
          @context.refute File.exist?(fpath),     "Directory '#{fpath}' exists unexpectedly."
        end
      end

      def not_exist?
        _mark_as_tested()
        fpath = @actual
        @context.assert ! File.exist?(fpath), "'#{fpath}' exists unexpectedly." unless @not
        @context.refute ! File.exist?(fpath), "'#{fpath}' doesn't exist."       if     @not
        self
      end

    end


  end


end
