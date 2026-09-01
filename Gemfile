# frozen_string_literal: true

source "https://gem.coop"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

group :test do
	gem "sus"
	gem "quickdraw", github: "joeldrapper/quickdraw"
	gem "simplecov", require: false
	gem "selenium-webdriver"
end

gem "nokogiri"

group :development do
	gem "rubocop"
	gem "ruby-lsp"
	gem "benchmark-ips"
end

# Our fork, until the formatter fixes land upstream: without them
# `compilation_equivalence_cases/modifier_if.rb` fails and compilation alters
# the re-emitted source. Point this back at `yippee-fun/refract` once merged.
gem "refract", github: "n-rodriguez/refract", branch: "fix/formatter-fidelity"
