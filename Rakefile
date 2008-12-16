require 'rubygems'
require 'rake'
require 'echoe'
require 'lib/wufoo/version'

Echoe.new('wufoo', Wufoo::Version) do |p|
  p.description = 'simple wrapper for the wufoo api'
  p.author = 'John Nunemaker'
  p.email = 'nunemaker@gmail.com'
  p.extra_deps = [['httparty', '0.2.2']]
end

desc 'Preps the gem for a new release'
task :prepare do
  %w[manifest build_gemspec].each do |task|
    Rake::Task[task].invoke
  end 
end