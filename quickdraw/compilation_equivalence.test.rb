# frozen_string_literal: true

class CompilationEquivalenceTest < Quickdraw::Test
	# Comparing the output before and after compilation says nothing when the
	# compiler silently skipped the method: `ClassCompiler` bails out on three
	# separate `return unless` guards, and an empty snippet list produces an
	# `eval` that redefines nothing, so `before == after` holds trivially.
	# These two checks prove compilation actually happened. Compiled methods are
	# eval'd with a starting line past the end of the original file, so a
	# `source_location` still inside the file means the method was skipped.
	def assert_compiled(component, path)
		assert(Phlex::Compiler::MAP.key?(path)) do
			"Expected a source map for #{path}, but the compiler produced none."
		end

		source_lines = File.read(path).count("\n")
		line = component.instance_method(:view_template).source_location[1]

		assert(line > source_lines) do
			"Expected #{component}#view_template to be redefined past line " \
				"#{source_lines} of #{path}, but it is still at line #{line} — " \
				"the compiler skipped it."
		end
	end

	Dir["./compilation_equivalence_cases/*.rb", base: File.dirname(__FILE__)].each do |file|
		test File.basename(file) do
			path = File.expand_path(file, File.dirname(__FILE__))
			load path

			class_name = File.basename(file, ".rb").split("_").map(&:capitalize).join
			component = Object.const_get(class_name)

			before = component.new.call
			Phlex::Compiler.compile(component)
			assert_compiled component, path
			after = component.new.call

			assert_equal after, before
		end
	end

	require_relative "../fixtures/page"
	require_relative "../fixtures/layout"

	test "benchmark fixtures" do
		before = Example::Page.new.call

		Phlex::Compiler.compile(Example::LayoutComponent)
		Phlex::Compiler.compile(Example::Page)

		assert_compiled Example::LayoutComponent, Object.const_source_location("Example::LayoutComponent")[0]
		assert_compiled Example::Page, Object.const_source_location("Example::Page")[0]

		after = Example::Page.new.call

		assert_equal after, before
	end
end
