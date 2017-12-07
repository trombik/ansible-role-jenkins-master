require "infrataster/rspec"
require "capybara"

ENV["VAGRANT_CWD"] = File.dirname(__FILE__)
ENV["LANG"] = "C"
#
# XXX "bundle exec vagrant" fails to load.
# https://github.com/bundler/bundler/issues/4602
#
# > bundle exec vagrant --version
# bundler: failed to load command: vagrant (/usr/local/bin/vagrant)
# Gem::Exception: can't find executable vagrant
#   /usr/local/lib/ruby/gems/2.2/gems/bundler-1.12.1/lib/bundler/rubygems_integration.rb:373:in `block in replace_bin_path'
#   /usr/local/lib/ruby/gems/2.2/gems/bundler-1.12.1/lib/bundler/rubygems_integration.rb:387:in `block in replace_bin_path'
#   /usr/local/bin/vagrant:23:in `<top (required)>'
#
# this causes "vagrant ssh-config" to fail, invoked in a spec file, i.e. when
# you need to ssh to a vagrant host.
#
# include the path of bin to vagrant
#
# rubocop:enable Metrics/LineLength
vagrant_real_path = ""
Bundler.with_clean_env do
  vagrant_real_path = File.dirname(`which vagrant`)
end
vagrant_bin_dir = File.dirname(vagrant_real_path)
ENV["PATH"] = "#{vagrant_bin_dir}:#{ENV['PATH']}"

Infrataster::Server.define(
  :server1,
  "192.168.21.200",
  vagrant: true
)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
