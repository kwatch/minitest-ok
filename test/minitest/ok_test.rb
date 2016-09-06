# -*- coding: utf-8 -*-

###
### $Release: 0.2.0 $
### $Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $
### $License: MIT License $
###


require_relative '../test_helper'


describe Minitest::Ok::AssertionObject do

  def should_not_raise
    begin
      yield
    rescue Exception => ex
      assert false, "Nothing should not be raised, but #{ex.class} raised.\n[Message] #{ex}"
    end
  end

  def should_raise
    begin
      yield
    rescue Minitest::Assertion => ex
      return ex
    else
      assert false, "Assertion should be raised, but nothing raised."
    end
  end


  describe '#==' do

    it "calls assert_equal()" do
      should_not_raise  { ok {1+1} == 2 }
      ex = should_raise { ok {1+1} == 3 }
      msg = ("Expected: 3\n" +
             "  Actual: 2")
      assert_equal msg, ex.message
    end

    it "calls refute_equal() after NOT() called." do
      should_not_raise  { ok {1+1}.NOT == 3 }
      ex = should_raise { ok {1+1}.NOT == 2 }
      msg = "Expected 2 to not be equal to 2."
      assert_equal msg, ex.message
    end

  end


  describe '#!=' do

    it "calls refute_equal()." do
      should_not_raise  { ok {1+1} != 3 }
      ex = should_raise { ok {1+1} != 2 }
      msg = "Expected 2 to not be equal to 2."
      assert_equal msg, ex.message
    end

    it "calls assert_equal() after NOT() called." do
      should_not_raise  { ok {1+1}.NOT != 2 }
      ex = should_raise { ok {1+1}.NOT != 3 }
      msg = ("Expected: 3\n" +
             "  Actual: 2")
      assert_equal msg, ex.message
    end

  end


  describe '#>' do

    it "calls assert_operator(:>)." do
      should_not_raise  { ok {1+1} > 1 }
      ex = should_raise { ok {1+1} > 2 }
      ex = should_raise { ok {1+1} > 3 }
      msg = "Expected 2 to be > 3."
      assert_equal msg, ex.message
    end

    it "calls refute_operator(:>) after NOT() called." do
      should_not_raise  { ok {1+1}.NOT > 3 }
      should_not_raise  { ok {1+1}.NOT > 2 }
      ex = should_raise { ok {1+1}.NOT > 1 }
      msg = "Expected 2 to not be > 1."
      assert_equal msg, ex.message
    end

  end


  describe '#>=' do

    it "calls assert_operator(:>=)." do
      should_not_raise  { ok {1+1} >= 1 }
      should_not_raise  { ok {1+1} >= 2 }
      ex = should_raise { ok {1+1} >= 3 }
      msg = "Expected 2 to be >= 3."
      assert_equal msg, ex.message
    end

    it "calls refute_operator(:>=) after NOT() called." do
      should_not_raise  { ok {1+1}.NOT >= 3 }
      ex = should_raise { ok {1+1}.NOT >= 2 }
      ex = should_raise { ok {1+1}.NOT >= 1 }
      msg = "Expected 2 to not be >= 1."
      assert_equal msg, ex.message
    end

  end


  describe '#<' do

    it "calls assert_operator(:<)." do
      should_not_raise  { ok {1+1} < 3 }
      ex = should_raise { ok {1+1} < 2 }
      ex = should_raise { ok {1+1} < 1 }
      msg = "Expected 2 to be < 1."
      assert_equal msg, ex.message
    end

    it "calls refute_operator(:<) after NOT() called." do
      should_not_raise  { ok {1+1}.NOT < 1 }
      should_not_raise  { ok {1+1}.NOT < 2 }
      ex = should_raise { ok {1+1}.NOT < 3 }
      msg = "Expected 2 to not be < 3."
      assert_equal msg, ex.message
    end

  end


  describe '#<=' do

    it "calls assert_operator(:<=)." do
      should_not_raise  { ok {1+1} <= 3 }
      should_not_raise  { ok {1+1} <= 2 }
      ex = should_raise { ok {1+1} <= 1 }
      msg = "Expected 2 to be <= 1."
      assert_equal msg, ex.message
    end

    it "calls refute_operator(:<=) after NOT() called." do
      should_not_raise  { ok {1+1}.NOT <= 1 }
      ex = should_raise { ok {1+1}.NOT <= 2 }
      ex = should_raise { ok {1+1}.NOT <= 3 }
      msg = "Expected 2 to not be <= 3."
      assert_equal msg, ex.message
    end

  end


  describe '#===' do

    it "calls assert_operator(:===)." do
      should_not_raise  { ok {String} === 'foo' }
      should_not_raise  { ok {/\d+/ } === '123' }
      ex = should_raise { ok {String} === 123   }
      msg = 'Expected String to be === 123.'
      assert_equal msg, ex.message
    end

    it "calls refuse_operator(:===) after NOT() called." do
      should_not_raise  { ok {String}.NOT === 123   }
      should_not_raise  { ok {/\d+/ }.NOT === 'abc' }
      ex = should_raise { ok {String}.NOT === '123' }
      msg = 'Expected String to not be === "123".'
      assert_equal msg, ex.message
    end

  end


  describe '#=~' do

    it "calls assert_match()." do
      should_not_raise  { ok {"hom"} =~ /\w+/ }
      ex = should_raise { ok {"hom"} =~ /\d+/ }
      msg = 'Expected /\d+/ to match "hom".'
      assert_equal msg, ex.message
    end

    it "calls refute_match() after NOT() called." do
      should_not_raise  { ok {"hom"}.NOT =~ /\d+/ }
      ex = should_raise { ok {"hom"}.NOT =~ /\w+/ }
      msg = 'Expected /\w+/ to not match "hom".'
      assert_equal msg, ex.message
    end

  end


  describe '#!~' do

    it "calls refute_match()." do
      should_not_raise  { ok {"hom"} !~ /\d+/ }
      ex = should_raise { ok {"hom"} !~ /\w+/ }
      msg = 'Expected /\w+/ to not match "hom".'
      assert_equal msg, ex.message
    end

    it "calls assert_match() after NOT() called." do
      should_not_raise  { ok {"hom"}.NOT !~ /\w+/ }
      ex = should_raise { ok {"hom"}.NOT !~ /\d+/ }
      msg = 'Expected /\d+/ to match "hom".'
      assert_equal msg, ex.message
    end

  end


  describe '#is_a?' do

    it "calls assert_kind_of()." do
      should_not_raise  { ok {"hom"}.is_a?(String) }
      ex = should_raise { ok {"hom"}.is_a?(Array)  }
      msg = 'Expected "hom" to be a kind of Array, not String.'
      assert_equal msg, ex.message
    end

    it "calls refute_kind_of() after NOT() called." do
      should_not_raise  { ok {"hom"}.NOT.is_a?(Array) }
      ex = should_raise { ok {"hom"}.NOT.is_a?(String) }
      msg = 'Expected "hom" to not be a kind of String.'
      assert_equal msg, ex.message
    end

  end


  describe '#kind_of?' do

    it "calls assert_kind_of()." do
      should_not_raise  { ok {"hom"}.kind_of?(String) }
      ex = should_raise { ok {"hom"}.kind_of?(Array)  }
      msg = 'Expected "hom" to be a kind of Array, not String.'
      assert_equal msg, ex.message
    end

    it "calls refute_kind_of() after NOT() called." do
      should_not_raise  { ok {"hom"}.NOT.kind_of?(Array) }
      ex = should_raise { ok {"hom"}.NOT.kind_of?(String) }
      msg = 'Expected "hom" to not be a kind of String.'
      assert_equal msg, ex.message
    end

  end


  describe '#instance_of?' do

    it "calls assert_instance_of()." do
      should_not_raise  { ok {123}.instance_of?(Fixnum)  }
      ex = should_raise { ok {123}.instance_of?(Integer) }
      msg = 'Expected 123 to be an instance of Integer, not Fixnum.'
      assert_equal msg, ex.message
    end

    it "calls refute_instance_of() after NOT() called." do
      should_not_raise  { ok {123}.NOT.instance_of?(Integer) }
      ex = should_raise { ok {123}.NOT.instance_of?(Fixnum)  }
      msg = 'Expected 123 to not be an instance of Fixnum.'
      assert_equal msg, ex.message
    end

  end


  describe '#same?' do

    it "calls assert_same()." do
      should_not_raise  { ok {123}.same?(123) }
      ex = should_raise { ok {[1]}.same?([1]) }
      msg = /^Expected \[1\] \(oid=\d+\) to be the same as \[1\] \(oid=\d+\)\.$/
      assert_match msg, ex.message
    end

    it "calls refute_same() after NOT() called." do
      should_not_raise  { ok {[1]}.NOT.same?([1]) }
      ex = should_raise { ok {123}.NOT.same?(123) }
      msg = /^Expected 123 \(oid=\d+\) to not be the same as 123 \(oid=\d+\)\.$/
      assert_match msg, ex.message
    end

  end


  describe '#empty?' do

    it "calls assert_empty()." do
      should_not_raise  { ok {[ ]}.empty? }
      ex = should_raise { ok {[1]}.empty? }
      msg = "Expected [1] to be empty."
      assert_equal msg, ex.message
    end

    it "calls refute_empty() after NOT() called." do
      should_not_raise  { ok {[1]}.NOT.empty? }
      ex = should_raise { ok {[ ]}.NOT.empty? }
      msg = "Expected [] to not be empty."
      assert_equal msg, ex.message
    end

  end


  describe '#in_delta?' do

    it "calls assert_in_delta()." do
      should_not_raise  { ok {3.14159}.in_delta?(3.14, 0.01)  }
      ex = should_raise { ok {3.14159}.in_delta?(3.14, 0.001) }
      msg = /^Expected \|?3\.14 - 3\.14159\|? \(0\.0015899\d+\) to be <=? 0\.001\.$/
      assert_match msg, ex.message
    end

    it "calls refute_in_delta() after NOT() called." do
      should_not_raise  { ok {3.14159}.NOT.in_delta?(3.14, 0.001) }
      ex = should_raise { ok {3.14159}.NOT.in_delta?(3.14, 0.01)  }
      msg = /^Expected \|?3\.14 - 3\.14159\|? \(0\.0015899\d+\) to not be <=? 0\.01\.$/
      assert_match msg, ex.message
    end

  end


  describe '#in_epsilon?' do

    it "calls assert_in_epsilon()." do
      should_not_raise  { ok {3.14159}.in_epsilon?(3.14, 0.001)  }
      ex = should_raise { ok {3.14159}.in_epsilon?(3.14, 0.0001) }
      msg = /^Expected \|?3\.14 - 3\.14159\|? \(0.00158999\d+\) to be <=? 0\.000314000\d+\.$/
      assert_match msg, ex.message
    end

    it "calls refute_in_epsilon() after NOT() called." do
      should_not_raise  { ok {3.14159}.NOT.in_epsilon?(3.14, 0.0001) }
      ex = should_raise { ok {3.14159}.NOT.in_epsilon?(3.14, 0.001)  }
      msg = /^Expected \|?3\.14 - 3\.14159\|? \(0.00158999\d+\) to not be <=? 0\.00314\.$/
      assert_match msg, ex.message
    end

  end


  describe '#raise?' do

    it "calls assert_raises()." do
      should_not_raise  { ok {proc{1/0}}.raise?(ZeroDivisionError) }
      ex = should_raise { ok {proc{1/1}}.raise?(ZeroDivisionError) }
      msg = "ZeroDivisionError expected but nothing was raised."
      assert_equal msg, ex.message
    end

    it "fails when exception raised after NOT() called." do
      should_not_raise  { ok {proc{1/1}}.NOT.raise?(ZeroDivisionError) }
      #
      ex = should_raise { ok {proc{1/0}}.NOT.raise?(ZeroDivisionError) }
      msg = "Exception ZeroDivisionError raised unexpectedly."
      assert_equal msg, ex.message
      #
      assert_raises(ZeroDivisionError) do
        ok {proc{1/0}}.NOT.raise?(NoMethodError)
      end
    end

    it "can take error message string in addition to exception class." do
      should_not_raise  { ok {proc{1/0}}.raise?(ZeroDivisionError, "divided by 0") }
      ex = should_raise { ok {proc{1/0}}.raise?(ZeroDivisionError, "foobar") }
      expected = "Expected: \"foobar\"\n  Actual: \"divided by 0\""
      assert_equal expected, ex.message
    end

    it "can take error message regexp instead of string." do
      should_not_raise  { ok {proc{1/0}}.raise?(ZeroDivisionError, /by [0]/) }
      ex = should_raise { ok {proc{1/0}}.raise?(ZeroDivisionError, /by 99/) }
      expected = "Expected /by 99/ to match \"divided by 0\"."
      assert_equal expected, ex.message
    end

  end


  describe '#throw?' do

    it "calls assert_throws()." do
      should_not_raise  { ok {proc { throw :exit }}.throw?(:exit) }
      ex = should_raise { ok {proc { throw :exit }}.throw?(:finish) }
      msg = "Expected :finish to have been thrown, not :exit."
      assert_equal msg, ex.message
      ex = should_raise { ok {proc { var = 1 + 1 }}.throw?(:exit) }
      msg = "Expected :exit to have been thrown."
      assert_equal msg, ex.message
    end

    it "raises error because refute_raise() is not defiend in Minitest." do
      ex = assert_raises(RuntimeError) do
        ok {proc { throw :exit }}.NOT.throw?(:finish)
      end
      msg = "NOT.throw? is unsupported because refute_throws() is not defined in Minitest."
      assert_equal msg, ex.message
    end

  end


  describe '#respond_to?' do

    it "calls assert_respond_to()." do
      should_not_raise  { ok {[1]}.respond_to?(:each) }
      ex = should_raise { ok {123}.respond_to?(:each) }
      msg = "Expected 123 (Fixnum) to respond to #each."
      assert_equal msg, ex.message
    end

    it "calls refute_respond_to() after NOT() called." do
      should_not_raise  { ok {[1]}.respond_to?(:each) }
      ex = should_raise { ok {123}.respond_to?(:each) }
      msg = "Expected 123 (Fixnum) to respond to #each."
      assert_equal msg, ex.message
    end

  end


  describe '#include?' do

    it "calls assert_includes()." do
      should_not_raise  { ok {1..9}.include?(2) }
      ex = should_raise { ok {1..9}.include?(0) }
      msg = "Expected 1..9 to include 0."
      assert_equal msg, ex.message
    end

    it "calls refute_includes() after NOT() called." do
      should_not_raise  { ok {1..9}.NOT.include?(0) }
      ex = should_raise { ok {1..9}.NOT.include?(2) }
      msg = "Expected 1..9 to not include 2."
      assert_equal msg, ex.message
    end

  end


  describe '#in?' do

    it "calls assert_includes()." do
      should_not_raise  { ok {1}.in?(1..9) }
      ex = should_raise { ok {0}.in?(1..9) }
      msg = "Expected 1..9 to include 0."
      assert_equal msg, ex.message
    end

    it "calls refute_includes() after NOT() called." do
      should_not_raise  { ok {0}.NOT.in?(1..9) }
      ex = should_raise { ok {1}.NOT.in?(1..9) }
      msg = "Expected 1..9 to not include 1."
      assert_equal msg, ex.message
    end

  end


  describe '#output?' do

    it "calls assert_output()." do
      should_not_raise  { ok {proc {puts 123}}.output?("123\n", "") }
      ex = should_raise { ok {proc {puts 123}}.output?("", "123\n") }
      msg = [
        'In stderr.',
        '--- expected',
        '+++ actual',
        '@@ -1,2 +1 @@',
        '-"123',
        '-"',
        '+""',
        '',
      ].join("\n")
      assert_equal msg, ex.message
    end

    it "raises error when called after NOT()." do
      ex = assert_raises(RuntimeError) do
        ok {proc { nil }}.NOT.output?("123", "")
      end
      msg = "use ok().silent? instead of ok().NOT.output?."
      assert_equal msg, ex.message
    end

  end


  describe '#silent?' do

    it "calls assert_silent()." do
      should_not_raise  { ok {proc {nil}}.silent? }
      ex = should_raise { ok {proc {puts 123}}.silent? }
      msg = [
        'In stdout.',
        '--- expected',
        '+++ actual',
        '@@ -1 +1,2 @@',
        '-""',
        '+"123',
        '+"',
        '',
      ].join("\n")
      assert_equal msg, ex.message
    end

    it "raises error when called after NOT()." do
      ex = assert_raises(RuntimeError) do
        ok {proc { puts 123 }}.NOT.silent?
      end
      msg = "use ok().output? instead of ok().NOT.silent?."
      assert_equal msg, ex.message
    end

  end


  describe '#frozen?' do

    it "calls assert_predicate()." do
      should_not_raise  { ok {"".freeze}.frozen? }
      ex = should_raise { ok {"".dup() }.frozen? }
      msg = 'Expected "" to be frozen?.'
      assert_equal msg, ex.message
    end

    it "calls refute_predicate() after NOT() called." do
      should_not_raise  { ok {"".dup() }.NOT.frozen? }
      ex = should_raise { ok {"".freeze}.NOT.frozen? }
      msg = 'Expected "" to not be frozen?.'
      assert_equal msg, ex.message
    end

  end


  describe '#tainted?' do

    it "calls assert_predicate()." do
      should_not_raise  { ok {"".taint}.tainted? }
      ex = should_raise { ok {"".dup()}.tainted? }
      msg = 'Expected "" to be tainted?.'
      assert_equal msg, ex.message
    end

    it "calls refute_predicate() after NOT() called." do
      should_not_raise  { ok {"".dup()}.NOT.tainted? }
      ex = should_raise { ok {"".taint}.NOT.tainted? }
      msg = 'Expected "" to not be tainted?.'
      assert_equal msg, ex.message
    end

  end


  describe '#instance_variable_defined?' do

    def obj_with_x(x)
      obj = Object.new
      obj.instance_variable_set('@x', x)
      return obj
    end

    it "calls assert()." do
      obj = obj_with_x(10)
      should_not_raise  { ok {obj}.instance_variable_defined?('@x') }
      ex = should_raise { ok {obj}.instance_variable_defined?('@y') }
      msg = /^Expected #<Object:\w+ @x=10> to have instance variable \@y, but not\.$/
      assert_match msg, ex.message
    end

    it "calls refute() after NOT() called." do
      obj = obj_with_x(10)
      should_not_raise  { ok {obj}.NOT.instance_variable_defined?('@y') }
      ex = should_raise { ok {obj}.NOT.instance_variable_defined?('@x') }
      msg = /^Expected #<Object:\w+ @x=10> not to have instance variable \@x, but has it\.$/
      assert_match msg, ex.message
    end

  end


  describe '#method_missing()' do

    it "calls super when not predicate." do
      x = nil
      ex = assert_raises(NoMethodError) do
        (x = ok {nil}).append('bar')
      end
      x._mark_as_tested()
      msg = /^undefined method `append' for \#<Mini[tT]est::Ok::AssertionObject:\w+>$/
      assert_match msg, ex.message
      #
      ex = assert_raises(NoMethodError) do
        ok {nil}.start_with?('bar')
      end
      msg = "undefined method `start_with?' for nil:NilClass"
      assert_equal msg, ex.message
    end

    it "calles assert()." do
      should_not_raise  { ok {"foobar"}.start_with?('foo') }
      ex = should_raise { ok {"foobar"}.start_with?('bar') }
      msg = 'Expected "foobar".start_with?("bar") but failed.'
      assert_equal msg, ex.message
      #
      should_not_raise  { ok {[1,2,3]}.all? {|x| x <= 3 }}
      should_not_raise  { ok {[1,2,3]}.any? {|x| x % 2 == 0}}
    end

    it "calles refute() after NOT() called." do
      should_not_raise  { ok {"foobar"}.NOT.start_with?('bar') }
      ex = should_raise { ok {"foobar"}.NOT.start_with?('foo') }
      msg = 'Expected "foobar".start_with?("foo") to fail but succeeded.'
      assert_equal msg, ex.message
    end

    it "calls corresponding 'assert_xxxx' when 'xxxx?' called." do
      MiniTest::Assertions.class_eval do
        def assert_utf8(str)
          assert str.encoding == Encoding::UTF_8, "Expected utf-8 string but not."
        end
      end
      utf8  = "foobar".force_encoding('utf-8')
      ascii = "foobar".force_encoding('us-ascii')
      should_not_raise  { ok {utf8 }.utf8? }
      ex = should_raise { ok {ascii}.utf8? }
      msg = 'Expected utf-8 string but not.'
      assert_equal msg, ex.message
    end

    it "calls corresponding 'refute_xxxx' when 'xxxx?' called after NOT() called." do
      MiniTest::Assertions.class_eval do
        def refute_utf8(str)
          refute str.encoding == Encoding::UTF_8, "Expected non utf-8 string but it is."
        end
      end
      utf8  = "foobar".force_encoding('utf-8')
      ascii = "foobar".force_encoding('us-ascii')
      should_not_raise  { ok {ascii}.NOT.utf8? }
      ex = should_raise { ok {utf8 }.NOT.utf8? }
      msg = 'Expected non utf-8 string but it is.'
      assert_equal msg, ex.message
    end

  end


  describe '#truthy?' do

    it "calles assert()." do
      should_not_raise  { ok {123}.truthy? }
      ex = should_raise { ok {nil}.truthy? }
      msg = 'Expected (!! nil) == true, but not.'
      assert_equal msg, ex.message
    end

    it "calles refute() after NOT() called." do
      should_not_raise  { ok {nil}.NOT.truthy? }
      ex = should_raise { ok {123}.NOT.truthy? }
      msg = 'Expected (!! 123) == false, but not.'
      assert_equal msg, ex.message
    end

  end


  describe '#falthy?' do

    it "calles refute()." do
      should_not_raise  { ok {nil}.falthy? }
      ex = should_raise { ok {123}.falthy? }
      msg = 'Expected (!! 123) == false, but not.'
      assert_equal msg, ex.message
    end

    it "calles assert() after NOT() called." do
      should_not_raise  { ok {123}.NOT.falthy? }
      ex = should_raise { ok {nil}.NOT.falthy? }
      msg = 'Expected (!! nil) == true, but not.'
      assert_equal msg, ex.message
    end

  end


  describe '#attr' do

    class User
      def initialize(name, age)
        @name, @age = name, age
      end
      attr_accessor :name, :age
    end

    it "calles assert_equal()." do
      user = User.new('Haruhi', 16)
      should_not_raise  { ok {user}.attr(:name, 'Haruhi').attr(:age, 16) }
      ex = should_raise { ok {user}.attr(:name, 'Haruhi').attr(:age, 12) }
      msg = ("Expected <object>.age == <exected>, but failed.\n" +
             " (object: #<User:0xXXXXXX @name=\"Haruhi\", @age=16>).\n" +
             "Expected: 12\n" +
             "  Actual: 16")
      assert_equal msg, ex.message.gsub(/<User:0x\w+/, '<User:0xXXXXXX')
    end

    it "calles refute_equal() after NOT() called." do
      user = User.new('Haruhi', 16)
      should_not_raise  { ok {user}.NOT.attr(:name, 'Suzumiya').attr(:age, 12) }
      ex = should_raise { ok {user}.NOT.attr(:name, 'Suzumiya').attr(:age, 16) }
      msg = ("Expected <object>.age != <exected>, but failed.\n" +
             " (object: #<User:0xXXXXXX @name=\"Haruhi\", @age=16>).\n" +
             "Expected 16 to not be equal to 16.")
      assert_equal msg, ex.message.gsub(/<User:0x\w+/, '<User:0xXXXXXX')
    end

  end


  describe '#attrs' do

    class User
      def initialize(name, age)
        @name, @age = name, age
      end
      attr_accessor :name, :age
    end

    it "calles assert_equal()." do
      user = User.new('Haruhi', 16)
      should_not_raise  { ok {user}.attrs(name: 'Haruhi', age: 16) }
      ex = should_raise { ok {user}.attrs(name: 'Haruhi', age: 12) }
      msg = ("Expected <object>.age == <exected>, but failed.\n" +
             " (object: #<User:0xXXXXXX @name=\"Haruhi\", @age=16>).\n" +
             "Expected: 12\n" +
             "  Actual: 16")
      assert_equal msg, ex.message.gsub(/<User:0x\w+/, '<User:0xXXXXXX')
    end

    it "calles refute_equal() after NOT() called." do
      user = User.new('Haruhi', 16)
      should_not_raise  { ok {user}.NOT.attrs(name: 'Suzumiya', age: 12) }
      ex = should_raise { ok {user}.NOT.attrs(name: 'Suzumiya', age: 16) }
      msg = ("Expected <object>.age != <exected>, but failed.\n" +
             " (object: #<User:0xXXXXXX @name=\"Haruhi\", @age=16>).\n" +
             "Expected 16 to not be equal to 16.")
      assert_equal msg, ex.message.gsub(/<User:0x\w+/, '<User:0xXXXXXX')
    end

  end


  describe '#item' do

    it "calles assert_equal()." do
      user = {:name=>'Haruhi', :age=>16}
      should_not_raise  { ok {user}.item(:name, 'Haruhi').item(:age, 16) }
      ex = should_raise { ok {user}.item(:name, 'Haruhi').item(:age, 12) }
      msg = ("Expected <object>[:age] == <exected>, but failed.\n" +
             " (object: {:name=>\"Haruhi\", :age=>16}).\n" +
             "Expected: 12\n" +
             "  Actual: 16")
      assert_equal msg, ex.message
    end

    it "calles refute_equal() after NOT() called." do
      user = {:name=>'Haruhi', :age=>16}
      should_not_raise  { ok {user}.NOT.item(:name, 'Suzumiya').item(:age, 12) }
      ex = should_raise { ok {user}.NOT.item(:name, 'Suzumiya').item(:age, 16) }
      msg = ("Expected <object>[:age] != <exected>, but failed.\n" +
             " (object: {:name=>\"Haruhi\", :age=>16}).\n" +
             "Expected 16 to not be equal to 16.")
      assert_equal msg, ex.message
    end

  end


  describe '#items' do

    it "calles assert_equal()." do
      user = {:name=>'Haruhi', :age=>16}
      should_not_raise  { ok {user}.items(name: 'Haruhi', age: 16) }
      ex = should_raise { ok {user}.items(name: 'Haruhi', age: 12) }
      msg = ("Expected <object>[:age] == <exected>, but failed.\n" +
             " (object: {:name=>\"Haruhi\", :age=>16}).\n" +
             "Expected: 12\n" +
             "  Actual: 16")
      assert_equal msg, ex.message
    end

    it "calles refute_equal() after NOT() called." do
      user = {:name=>'Haruhi', :age=>16}
      should_not_raise  { ok {user}.NOT.items(name: 'Suzumiya', age: 12) }
      ex = should_raise { ok {user}.NOT.items(name: 'Suzumiya', age: 16) }
      msg = ("Expected <object>[:age] != <exected>, but failed.\n" +
             " (object: {:name=>\"Haruhi\", :age=>16}).\n" +
             "Expected 16 to not be equal to 16.")
      assert_equal msg, ex.message
    end

  end


  describe '#file_exist?' do

    it "calles assert()." do
      fpath = __FILE__
      should_not_raise  { ok {fpath}.file_exist? }
      #
      ex = should_raise { ok {'XXX'}.file_exist? }
      msg = "File 'XXX' doesn't exist."
      assert_equal msg, ex.message
      #
      ex = should_raise { ok {Dir.pwd}.file_exist? }
      msg = "'#{Dir.pwd}' is not a file."
      assert_equal msg, ex.message
    end

    it "calles assert() after NOT() called." do
      fpath = __FILE__
      should_not_raise  { ok {'XXX'}.NOT.file_exist? }
      ex = should_raise { ok {fpath}.NOT.file_exist? }
      msg = "File '#{fpath}' exists unexpectedly."
      assert_equal msg, ex.message
    end

  end


  describe '#dir_exist?' do

    it "calles assert()." do
      dpath = Dir.pwd
      should_not_raise  { ok {dpath}.dir_exist? }
      #
      ex = should_raise { ok {'XXX'}.dir_exist? }
      msg = "Directory 'XXX' doesn't exist."
      assert_equal msg, ex.message
      #
      fpath = __FILE__
      ex = should_raise { ok {fpath}.dir_exist? }
      msg = "'#{fpath}' is not a directory."
      assert_equal msg, ex.message
    end

    it "calles assert() after NOT() called." do
      dpath = Dir.pwd
      should_not_raise  { ok {'XXX'}.NOT.dir_exist? }
      ex = should_raise { ok {dpath}.NOT.dir_exist? }
      msg = "Directory '#{dpath}' exists unexpectedly."
      assert_equal msg, ex.message
    end

  end


  describe '#not_exist?' do

    it "calles assert()." do
      fpath = __FILE__
      should_not_raise  { ok {'XXX'}.not_exist? }
      ex = should_raise { ok {fpath}.not_exist? }
      msg = "'#{fpath}' exists unexpectedly."
      assert_equal msg, ex.message
    end

    it "calles assert() after NOT() called." do
      fpath = __FILE__
      should_not_raise  { ok {fpath}.NOT.not_exist? }
      ex = should_raise { ok {'XXX'}.NOT.not_exist? }
      msg = "'XXX' doesn't exist."
      assert_equal msg, ex.message
    end

  end


end
