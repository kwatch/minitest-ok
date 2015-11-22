# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###

require 'minitest'


module Minitest


  module Assertions

    ##
    ## Helper method to call assertion methods.
    ## See AssertionObject class for details.
    ##
    ##   ok {1+1} == 2        # same as assert_equal 2, 1+1
    ##   ok {1+1} != 1        # same as refute_equal 1, 1+1
    ##   ok {1+1} >  1        # same as assert_operator 1+1, :>, 1
    ##   ok {1+1} <= 2        # same as assert_operator 1+1, :<=, 2
    ##   ok {'123'} =~ /\d+/  # same as assert_match /\d+/, '123'
    ##   ok {[]}.kind_of?(Array)     # same as assert_kind_of Array, []
    ##   ok {[]}.NOT.kind_of?(Hash)  # same as refute_kind_of Hash, []
    ##   ok {1..9}.include?(5)       # same as assert_includes 5, 1..9
    ##   ok {1..9}.NOT.include?(0)   # same as refute_includes 0, 1..9
    ##   ok {""}.truthy?      # same as assert true, !!""
    ##   ok {nil}.falthy?     # same as assert false, !!""
    ##
    ##   ex = ok { proc { 1 / 0 } }.raise?(ZeroDivisionError, "divided by 0")
    ##   p ex      #=> #<ZeroDivisionError: divided by 0>
    ##
    def ok
      actual = yield
      Ok::AssertionObject.new(actual, self, caller(1, 1).first)
    end

  end


  module Ok

    VERSION = '$Release: 0.0.0 $'.split()[1]


    class AssertionObject

      ## Don't create this object directly. Use <tt>ok {value}</tt> instead.
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

      ##
      ## Make logical condition reversed.
      ##
      ##   ok {[1,2,3]}.empty?       # Fail
      ##   ok {[1,2,3]}.NOT.empty?   # Pass
      ##
      def NOT()
        @not = ! @not
        self
      end

      ##
      ## Same as <tt>assert_equal()</tt>.
      ##
      ##   ok {1+1} == 2             # Pass
      ##   ok {1+1} == 1             # Fail
      ##
      def ==(expected)
        _mark_as_tested()
        @context.assert_equal expected, @actual  unless @not
        @context.refute_equal expected, @actual  if     @not
        self
      end

      ##
      ## Same as <tt>refute_equal()</tt>.
      ##
      ##   ok {1+1} != 1             # Pass
      ##   ok {1+1} != 2             # Fail
      ##
      def !=(expected)
        _mark_as_tested()
        @context.refute_equal expected, @actual  unless @not
        @context.assert_equal expected, @actual  if     @not
        self
      end

      ##
      ## Tests <tt>actual > expected</tt>.
      ##
      ##   ok {1+1} > 1             # Pass
      ##   ok {1+1} > 2             # Fail
      ##   ok {1+1} > 3             # Fail
      ##
      def >(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'>', expected  unless @not
        @context.refute_operator @actual, :'>', expected  if     @not
        self
      end

      ##
      ## Tests <tt>actual >= expected</tt>.
      ##
      ##   ok {1+1} >= 1             # Pass
      ##   ok {1+1} >= 2             # Pass
      ##   ok {1+1} >= 3             # Fail
      ##
      def >=(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'>=', expected  unless @not
        @context.refute_operator @actual, :'>=', expected  if     @not
        self
      end

      ##
      ## Tests <tt>actual < expected</tt>.
      ##
      ##   ok {1+1} < 3             # Pass
      ##   ok {1+1} < 2             # Fail
      ##   ok {1+1} < 1             # Fail
      ##
      def <(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'<', expected  unless @not
        @context.refute_operator @actual, :'<', expected  if     @not
        self
      end

      ##
      ## Tests <tt>actual <= expected</tt>.
      ##
      ##   ok {1+1} <= 3             # Pass
      ##   ok {1+1} <= 2             # Pass
      ##   ok {1+1} <= 1             # Fail
      ##
      def <=(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'<=', expected  unless @not
        @context.refute_operator @actual, :'<=', expected  if     @not
        self
      end

      ##
      ## Tests <tt>actual === expected</tt>.
      ##
      ##   ok {String} === 'foo'     # Pass
      ##   ok {/\d+/}  === '123'     # Pass
      ##
      def ===(expected)
        _mark_as_tested()
        @context.assert_operator @actual, :'===', expected  unless @not
        @context.refute_operator @actual, :'===', expected  if     @not
        self
      end

      ##
      ## Same as <tt>assert_match()</tt>.
      ##
      ##   ok {"abc"} =~ /\w+/        # Pass
      ##   ok {"abc"} =~ /\d+/        # Fail
      ##
      def =~(expected)
        _mark_as_tested()
        @context.assert_match expected, @actual  unless @not
        @context.refute_match expected, @actual  if     @not
        self
      end

      ##
      ## Same as <tt>refute_match()</tt>.
      ##
      ##   ok {"abc"} !~ /\d+/        # Pass
      ##   ok {"abc"} !~ /\w+/        # Fail
      ##
      def !~(expected)
        _mark_as_tested()
        @context.refute_match expected, @actual  unless @not
        @context.assert_match expected, @actual  if     @not
        self
      end

      ##
      ## Same as <tt>assert_kind_of()</tt>.
      ##
      ##   ok {123}.is_a?(Fixnum)     # Pass
      ##   ok {123}.is_a?(Integer)    # Pass
      ##   ok {123}.is_a?(Float)      # Fail
      ##
      def is_a?(expected)
        _mark_as_tested()
        @context.assert_kind_of expected, @actual  unless @not
        @context.refute_kind_of expected, @actual  if     @not
        self
      end

      alias kind_of? is_a?

      ##
      ## Same as <tt>assert_instance_of()</tt>.
      ##
      ##   ok {123}.instance_of?(Fixnum)     # Pass
      ##   ok {123}.instance_of?(Integer)    # Fail
      ##
      def instance_of?(expected)
        _mark_as_tested()
        @context.assert_instance_of expected, @actual  unless @not
        @context.refute_instance_of expected, @actual  if     @not
        self
      end

      ##
      ## Same as <tt>assert_same()</tt>.
      ##
      ##   arr = [1]
      ##   ok {arr}.same?(arr)               # Pass
      ##   ok {arr}.same?([1])               # Fail
      ##   ok {arr}.NOT.same?([1])           # Pass
      ##
      def same?(expected)
        _mark_as_tested()
        @context.assert_same expected, @actual  unless @not
        @context.refute_same expected, @actual  if     @not
        self
      end

      ##
      ## Same as <tt>assert_empty()</tt>.
      ##
      ##   ok {""}.empty?                    # Pass
      ##   ok {[]}.empty?                    # Pass
      ##   ok {"X"}.empty?                   # Fail
      ##   ok {"X"}.NOT.empty?               # Pass
      ##
      def empty?
        _mark_as_tested()
        @context.assert_empty @actual  unless @not
        @context.refute_empty @actual  if     @not
        self
      end

      ##
      ## Same as <tt>assert_in_delta()</tt>.
      ##
      ##   ok {3.14159}.in_delta?(3.14, 0.01)       # Pass
      ##   ok {3.14159}.in_delta?(3.14, 0.001)      # Fail
      ##
      def in_delta?(expected, delta)
        _mark_as_tested()
        @context.assert_in_delta(expected, @actual, delta)  unless @not
        @context.refute_in_delta(expected, @actual, delta)  if     @not
        self
      end

      ##
      ## Same as <tt>assert_in_epsilon()</tt>.
      ##
      ##   ok {3.14159}.in_epsilon?(3.14, 0.001)    # Pass
      ##   ok {3.14159}.in_epsilon?(3.14, 0.0001)   # Fail
      ##
      def in_epsilon?(expected, epsilon)
        _mark_as_tested()
        @context.assert_in_epsilon(expected, @actual, epsilon)  unless @not
        @context.refute_in_epsilon(expected, @actual, epsilon)  if     @not
        self
      end

      ##
      ## Same as <tt>assert_raises()</tt>.
      ##
      ##   ex = ok { proc { 1/0 } }.raise?(ZeroDivisionError)  # Pass
      ##   p ex.class        #=> ZeroDivisionError
      ##   ex = ok { proc { 1/0 } }.raise?(ZeroDivisionError, "divided by zero")
      ##   ex = ok { proc { 1/0 } }.raise?(ZeroDivisionError, /^divided by zero$/)
      ##
      ##   ok { proc { 1 / 1 } }.NOT.raise?(Exception)         # Pass
      ##
      def raise?(exception_class, message=nil)
        _mark_as_tested()
        ex = nil
        unless @not
          ex = @context.assert_raises(exception_class) { @actual.call }
        else
          begin
            @actual.call
          rescue exception_class => ex
            @context.assert false, "Exception #{ex.class} raised unexpectedly."
          else
            @context.assert true
          end
        end
        return ex   # not self!
      end

      ##
      ## Same as <tt>assert_throws()</tt>.
      ##
      ##   ok {proc {throw :exit}}.throw?(:exit)   # Pass
      ##   ok {proc {nil}}.NOT.throw?(:exit)       # NOT AVAILABLE
      ##
      def throw?(sym)
        _mark_as_tested()
        ! @not  or
          raise "NOT.throw? is unsupported because refute_throws() is not defined in Minitest."
        @context.assert_throws(sym) { @actual.call }
        self
      end

      ##
      ## Same as <tt>assert_respond_to()</tt>.
      ##
      ##   ok {"X"}.respond_to?(:each)     # Pass
      ##   ok {123}.respond_to?(:each)     # Fail
      ##
      def respond_to?(expected)
        _mark_as_tested()
        @context.assert_respond_to @actual, expected  unless @not
        @context.refute_respond_to @actual, expected  if     @not
        self
      end

      ##
      ## Same as <tt>assert_includes()</tt>.
      ##
      ##   ok {[1, 2, 3]}.include?(2)         # Pass
      ##   ok {[1, 2, 3]}.include?(0)         # Fail
      ##   ok {[1, 2, 3]}.NOT.include?(0)     # Pass
      ##
      def include?(expected)
        _mark_as_tested()
        @context.assert_includes @actual, expected  unless @not
        @context.refute_includes @actual, expected  if     @not
        self
      end

      ##
      ## Same as <tt>assert_output()</tt>.
      ##
      ##   ok {proc { puts 'X' }}.output?("X\n")  # Pass
      ##   ok {proc { x = 123  }}.NOT.output?     # NOT AVAILABLE
      ##
      def output?(stdout=nil, stderr=nil)
        _mark_as_tested()
        ! @not  or
          raise "use ok().silent? instead of ok().NOT.output?."
        @context.assert_output(stdout, stderr, &@actual)
        self
      end

      ##
      ## Same as <tt>assert_silent()</tt>.
      ##
      ##   ok {proc { x = 1234 }}.silent?       # Pass
      ##   ok {proc { puts 'X' }}.NOT.silent?   # NOT AVAILABLE
      ##
      def silent?
        _mark_as_tested()
        ! @not  or
          raise "use ok().output? instead of ok().NOT.silent?."
        @context.assert_silent(&@actual)
        self
      end

      ## for predicates

      ##
      ## Tests whether object is frozen or not.
      ##
      ##   ok {"foo".freeze}.frozen?     # Pass
      ##   ok {"foo"}.NOT.frozen?        # Pass
      ##
      def frozen?
        _mark_as_tested()
        @context.assert_predicate @actual, :frozen?  unless @not
        @context.refute_predicate @actual, :frozen?  if     @not
        self
      end

      ##
      ## Tests whether object is tainted or not.
      ##
      ##   ok {"foo".tainted}.tainted?   # Pass
      ##   ok {"foo"}.NOT.tainted?       # Pass
      ##
      def tainted?
        _mark_as_tested()
        @context.assert_predicate @actual, :tainted?  unless @not
        @context.refute_predicate @actual, :tainted?  if     @not
        self
      end

      ##
      ## Tests whether object has instance variable or not.
      ##
      ##   class User
      ##     def initialize(name); @name = name; end
      ##   end
      ##   ok {User.new('Haruhi')}.instance_variable_defined?('@name')  # Pass
      ##
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

      ##
      ## When <tt>ok {actual}.xxx?</tt> called, tries <tt>assert_xxx(actual)</tt> at first.
      ## If it is not defined, tries <tt>assert actual.xxx?</tt>.
      ##
      ##   ok {'logo.jpg'}.end_with?('.jpg')   # Pass
      ##   ok {[1, 2, 3]}.all? {|x| x <= 3 }   # Pass
      ##
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

      ##
      ## Tests whether actual is regarded as true-like value.
      ##
      ##   ok {true}.truthy?                 # Pass
      ##   ok {0}.truthy?                    # Pass
      ##   ok {""}.truthy?                   # Pass
      ##   ok {[]}.truthy?                   # Pass
      ##   ok {nil}.truthy?                  # Fail
      ##   ok {false}.truthy?                # Fail
      ##
      def truthy?
        _mark_as_tested()
        unless @not
          @context.assert @actual, proc { "Expected (!! #{@actual.inspect}) == true, but not."  }
        else
          @context.refute @actual, proc { "Expected (!! #{@actual.inspect}) == false, but not." }
        end
        self
      end

      ##
      ## Tests whether actual is false or nil.
      ##
      ##   ok {nil}.falthy?                  # Pass
      ##   ok {false}.falthy?                # Pass
      ##   ok {true}.falthy?                 # Fail
      ##   ok {0}.falthy?                    # Fail
      ##   ok {""}.falthy?                   # Fail
      ##   ok {[]}.falthy?                   # Fail
      ##
      def falthy?
        _mark_as_tested()
        unless @not
          @context.refute @actual, proc { "Expected (!! #{@actual.inspect}) == false, but not." }
        else
          @context.assert @actual, proc { "Expected (!! #{@actual.inspect}) == true, but not."  }
        end
        self
      end

      ##
      ## Tests whether file exists or not.
      ##
      ##   ok {__FILE__}.file_exist?         # Pass
      ##   ok {'/some/where'}.file_exist?    # Fail
      ##   ok {Dir.pwd}.file_exist?          # Fail
      ##
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

      ##
      ## Tests whether directory exists or not.
      ##
      ##   ok {Dir.pwd}.dir_exist?           # Pass
      ##   ok {'/some/where'}.dir_exist?     # Fail
      ##   ok {__FILE__}.dir_exist?          # Fail
      ##
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

      ##
      ## Tests whether file or directory not exist.
      ##
      ##   ok {'/some/where'}.not_exist?     # Pass
      ##   ok {__FILE__}.not_exist?          # Fail
      ##   ok {Dir.pwd}.not_exist?           # Fail
      ##
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
