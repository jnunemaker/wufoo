# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wufoo}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker"]
  s.date = %q{2008-12-16}
  s.description = %q{simple wrapper for the wufoo api}
  s.email = %q{nunemaker@gmail.com}
  s.extra_rdoc_files = ["lib/wufoo/client.rb", "lib/wufoo/submission.rb", "lib/wufoo/version.rb", "lib/wufoo.rb", "README"]
  s.files = ["examples/submission.rb", "History", "lib/wufoo/client.rb", "lib/wufoo/submission.rb", "lib/wufoo/version.rb", "lib/wufoo.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README", "test/test_client.rb", "test/test_helper.rb", "test/test_submission.rb", "test/test_wufoo.rb", "wufoo.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Wufoo", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wufoo}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{simple wrapper for the wufoo api}
  s.test_files = ["test/test_client.rb", "test/test_helper.rb", "test/test_submission.rb", "test/test_wufoo.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["= 0.2.2"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, ["= 0.2.2"])
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, ["= 0.2.2"])
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
