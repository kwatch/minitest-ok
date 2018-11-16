require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test


desc "show how to release"
task :help do
  rel = ENV['rel']  or abort "rake help: required 'rel=X.X.X'"
  rel =~ /(\d+\.\d+)/
  branch = "rel-#{$1}"
  puts <<END
How to release:

    $ git checkout dev
    $ git diff
    $ which ruby
    $ rake test                 # for confirmation
    $ git checkout -b #{branch}   # or git checkout #{branch}
    $ rake edit rel=#{rel}
    $ git diff
    $ git commit -a -m "release preparation for #{rel}"
    $ rake build                # for confirmation
    $ rake install              # for confirmation
    $ #rake release
    $ gem push pkg/minitest-ok-#{rel}.gem
    $ git tag v#{rel}
    $ git push -u origin #{branch}
    $ git push --tags
END

end


desc "edit files (for release preparation)"
task :edit do
  rel = ENV['rel']  or
    raise "ERROR: 'rel' environment variable expected."
  copyright = "copyright(c) 2015-2018 kuwata-lab.com all rights reserved"
  filenames = Dir[*%w[lib/**/*.rb test/**/*_test.rb test/test_helper.rb *.gemspec]]
  filenames.each do |fname|
    File.open(fname, 'r+', encoding: 'utf-8') do |f|
      content = f.read()
      x = content
      x = x.gsub(/\$Release:.*?\$/, "$Release: #{rel} $")
      x = x.gsub(/\$Copyright:.*?\$/, "$Copyright: #{copyright} $")
      if x == content
        puts "[_] #{fname}"
      else
        puts "[C] #{fname}"
        f.rewind()
        f.truncate(0)
        f.write(x)
      end
    end
  end
end
