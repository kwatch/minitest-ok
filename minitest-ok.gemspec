# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "minitest-ok"
  spec.version       = '$Release: 0.0.0 $'.split()[1]
  spec.authors       = ["makoto kuwata"]
  spec.email         = ["kwa(at)kuwata-lab.com"]

  spec.summary       = "'ok {1+1} == 2' instead of 'assert_equal 2, 1+1'"
  spec.description   = <<'END'
Using Minitest::Ok, you can write:

* 'ok {1+1} == 2' instead of 'assert_equal 2, 1+1',
* 'ok {1+1} > 0' instead of 'assert_operator 1+1, :>, 0',
* 'ok {5}.in?(1..9)' instead of 'assert_include 1..9, 5',

and so on.
END
  spec.homepage      = "https://github.com/kwatch/minitest-ok"
  spec.license       = "MIT-License"

  spec.files         = Dir[*%w[
                         README.md MIT-LICENSE Rakefile
                         lib/**/*.rb
                         test/test_helper.rb test/**/*_test.rb
                       ]]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'
  spec.add_runtime_dependency "minitest"
end
