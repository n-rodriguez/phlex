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

# Notre fork tant que les correctifs du formateur ne sont pas fusionnés en
# amont : sans eux, `compilation_equivalence_cases/modifier_if.rb` échoue,
# et la compilation altère la source réémise. À repointer sur
# `yippee-fun/refract` dès la fusion.
gem "refract", github: "n-rodriguez/refract", branch: "fix/formatter-fidelity"
