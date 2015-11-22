# Minitest::Ok

Minitest::Ok is a pretty good helper library for Minitest.
For example:

```ruby
ok {1+1} == 2               # same as assert_equal 2, 1+1
ok {1+1} >  1               # same as assert_operator 1+1, :>, 1
ok {'123'} =~ /\d+/         # same as assert_match /\d+/, '123'
ok {[]}.kind_of?(Array)     # same as assert_kind_of Array, []
ok {1..9}.include?(1)       # same as assert_includes 1, 1..9
ok {1}.in?(1..9)            # same as assert_includes 1, 1..9
ok {0}.NOT.in?(1..9)        # same as refute_includes 0, 1..9
ok {""}.truthy?             # same as assert true, !!""
ok {128}.even?              # same as assert_predicate 128, :even?
ok {obj}.attrs(x: 1, y: 2)  # same as assert obj.x == 1; assert obj.y == 2
ok {obj}.items(x: 1, y: 2)  # same as assert obj[:x] == 1; assert obj[:y] == 2
```


## Example

```ruby
# -*- coding: utf-8 -*-

require 'minitest/spec'
require 'minitest/autorun'

require 'minitest/ok'


describe 'Minitest::Ok' do

  it "helps to write assertions" do

    ## operators
    ok {1+1} == 2            # same as assert_equal 2, 1+1
    ok {1+1} != 1            # same as refute_equal 2, 1+1
    ok {1+1} >  1            # same as assert_operator 1+1, :>,  1
    ok {1+1} >= 2            # same as assert_operator 1+1, :>=, 2
    ok {1+1} <  3            # same as assert_operator 1+1, :<,  3
    ok {1+1} <= 2            # same as assert_operator 1+1, :<=, 2
    ok {Array} === [1, 2]    # same as assert_operator Array, :===, [1, 2]
    ok {/\d+/} === '123'     # same as assert_operator /\d+/, :===, '123'

    ## pattern matching
    ok {'123'} =~ /\d+/      # same as assert_match /\d+/, '123'
    ok {'abc'} !~ /\d+/      # same as refute_match /\d+/, 'abc'

    ## type
    arr = [1, 2, 3]
    ok {arr}.kind_of?(Array)       # same as assert_kind_of Array, [1,2,3]
    ok {arr}.is_a?(Array)          # 'is_a?' is an alias of 'kind_of?'
    ok {arr}.NOT.kind_of?(Hash)    # same as refute_kind_of Hash, [1,2,3]

    ok {1}.instance_of?(Fixnum)      # same as assert_instance_of Fixnum, 1
    ok {1}.NOT.instance_of?(Integer) # same as refute_instance_of Integer, 1

    ## identity
    arr = []
    ok {arr}.same?(arr)            # same as assert_same arr, arr
    ok {arr}.NOT.same?([])         # same as refute_same arr, []

    ## numeric difference
    ok {3.14159}.in_delta?(3.14, 0.01)       # same as assert_in_delta 3.14, 3.14159, 0.001
    ok {3.14159}.NOT.in_delta?(3.14, 0.001)  # same as refute_in_delta 3.14, 3.14159, 0.0001

    ok {3.14159}.in_epsilon?(3.14, 0.001)       # same as assert_in_epsilon 3.14, 3.14159, 0.001
    ok {3.14159}.NOT.in_epsilon?(3.14, 0.0001)  # same as refute_in_epsilon 3.14, 3.14159, 0.0001

    ## exception
    ex = ok {proc { 1/0 }}.raise?(ZeroDivisionError)  # same as assert_raise(...)
    ex = ok {proc { 1/0 }}.raise?(ZeroDivisionError, "divided by zero")
    ex = ok {proc { 1/0 }}.raise?(ZeroDivisionError, /^divided by zero$/)
    p ex     #=> #<ZeroDivisionError: divided by 0>
    ok {proc { 1/1 }}.NOT.raise?(Exception)

    ok {proc {throw :exit}}.throw?(:exit)  # same as assert_throws(:exit) {...}

    ## stdout and stderr
    ok {proc {puts 'X'}}.output?("X\n")  # same as assert_output {...}
    ok {proc {nil}}.silent?              # same as assert_silent {...}

    ## boolean
    ok {123}.truthy?               # similar to assert 123
    ok {0}.truthy?                 # similar to assert 0
    ok {""}.truthy?                # similar to assert ""
    ok {false}.falthy?             # similar to refute false
    ok {nil}.falthy?               # similar to refute nil

    ## predicates
    ok {""}.empty?                 # same as assert_empty? ""
    ok {[]}.empty?                 # same as assert_empty? []
    ok {[1,2,3]}.NOT.empty?        # same as refute_empty? [1,2,3]
    ok {1..9}.respond_to?(:each)   # same as assert_respond_to "foo", :each
    ok {1..9}.include?(1)          # same as assert_includes 1..9, 1
    ok {1..9}.NOT.include?(0)      # same as refute_includes 1..9, 0
    ok {1}.in?(1..9)               # same as assert_includes 1..9, 1
    ok {0}.NOT.in?(1..9)           # same as refute_includes 1..9, 0

    ok {'foo'.freeze}.frozen?      # same as assert 'foo'.freeze.frozen?
    ok {'foo'.taint}.tainted?      # same as assert 'foo'.taint.tainted?
    obj = Object.new
    obj.instance_variable_set('@x', 10)
    ok {obj}.instance_variable_defined?('@x')

    ok {'logo.png'}.end_with?('.png')   # same as assert 'logon.png'.start_with?('.png')
    ok {[1,2,3]}.any? {|x| x % 2 == 0}  # same as assert [1,2,3].any? {...}
    ok {[1,2,3]}.NOT.all? {|x| x < 0 }  # same as refute [1,2,3].all? {...}

    ## attribute
    time = Time.new(2015, 2, 14)
    ok {time}.attr(:year, 2015).attr(:month, 2).attr(:day, 14)
    ok {time}.attrs(year: 2015, month: 2, day: 14)

    ## key and value
    dict = {:name=>"Haruhi", :age=>16}
    ok {dict}.item(:name, "Haruhi").item(:age, 16)
    ok {dict}.items(name: "Haruhi", age: 16)

    ## file and directory
    ok {__FILE__}.file_exist?      # whether file exists or not
    ok {Dir.pwd }.dir_exist?       # whether directory exists or not
    ok {'/XXXX' }.not_exist?       # whether nothing exits or not

  end

end
```


## Copyright and License

$Copyright: copyright(c) 2015 kuwata-lab.com all rights reserved $

$License: MIT License $
