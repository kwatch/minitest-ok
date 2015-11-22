# -*- coding: utf-8 -*-

###
### $Release: 0.0.0 $
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
      msg = /^Expected \|3\.14 - 3\.14159\| \(0\.0015899\d+\) to be <= 0\.001\.$/
      assert_match msg, ex.message
    end

    it "calls refute_in_delta() after NOT() called." do
      should_not_raise  { ok {3.14159}.NOT.in_delta?(3.14, 0.001) }
      ex = should_raise { ok {3.14159}.NOT.in_delta?(3.14, 0.01)  }
      msg = /^Expected \|3\.14 - 3\.14159\| \(0\.0015899\d+\) to not be <= 0\.01\.$/
      assert_match msg, ex.message
    end

  end


  describe '#in_epsilon?' do

    it "calls assert_in_epsilon()." do
      should_not_raise  { ok {3.14159}.in_epsilon?(3.14, 0.001)  }
      ex = should_raise { ok {3.14159}.in_epsilon?(3.14, 0.0001) }
      msg = /^Expected \|3\.14 - 3\.14159\| \(0.00158999\d+\) to be <= 0\.000314000\d+\.$/
      assert_match msg, ex.message
    end

    it "calls refute_in_epsilon() after NOT() called." do
      should_not_raise  { ok {3.14159}.NOT.in_epsilon?(3.14, 0.0001) }
      ex = should_raise { ok {3.14159}.NOT.in_epsilon?(3.14, 0.001)  }
      msg = /^Expected \|3\.14 - 3\.14159\| \(0.00158999\d+\) to not be <= 0\.00314\.$/
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

    it "can take error message in addition to exception class." do
      should_not_raise  { ok {proc{1/0}}.raise?(ZeroDivisionError, "divided by 0") }
      should_not_raise  { ok {proc{1/0}}.raise?(ZeroDivisionError, /by [0]/) }
    end

    it "raises error because refute_raises() is not defiend in Minitest." do
      ex = assert_raises(RuntimeError) do
        ok {proc{1/0}}.NOT.raise?(ZeroDivisionError)
      end
      msg = "NOT.raise? is unsupported because refute_raises() is not defined in Minitest."
      assert_equal msg, ex.message
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


end
