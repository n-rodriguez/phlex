# frozen_string_literal: true

# Unit tests for the code `MethodCompiler` actually emits.
#
# `compilation_equivalence.test.rb` covers the end-to-end contract — compiled
# output must match interpreted output — but it can only catch a divergence
# that one of its fixtures happens to exercise. These tests look at the
# generated source directly, so a change in what the compiler emits shows up
# here even when no fixture renders it.
class CompilerTest < Quickdraw::Test
	# `MethodCompiler` walks Refract nodes, not Prism nodes, and returns a node
	# rather than a String — hence the conversion on the way in and the
	# formatting on the way out. It returns `nil` when nothing was optimised.
	#
	# `component:` is not exercised with a non-HTML component yet: compiling an
	# HTML element name against `Phlex::SVG` currently raises
	# `NameError: undefined method 'h1' for class 'Phlex::SVG'` from the
	# unguarded `bind_call` in `standard_element?`. Add that case once the
	# lookup is guarded.
	def compile(source, component: Phlex::HTML)
		node = Refract::Converter.new.visit(
			Prism.parse(source).value
		).statements.body.first

		compiled = Phlex::Compiler::MethodCompiler.new(component).compile(node)

		compiled && Refract::Formatter.new.format_node(compiled).source
	end

	# Every compiled method opens with the same preamble and is wrapped in the
	# backtrace-mapping rescue, so the tests below only vary the buffer writes.
	#
	# The buffer is read at each write rather than hoisted into the preamble:
	# `State#capture` swaps `@buffer` for the duration of a block, so a hoisted
	# reference would keep writing to the buffer the capture replaced.
	def compiled_method(body)
		<<~RUBY
			def foo
				begin
					__phlex_state__ = @_state
					__phlex_should_render__ = __phlex_state__.should_render?
					nil
					(if __phlex_should_render__
						#{body}
					end
					nil)
				rescue => __phlex_exception__
					Kernel.raise(__map_exception__(__phlex_exception__))
				end
			end
		RUBY
	end

	test "standard element with no arguments and no block" do
		assert_equivalent_ruby compile(<<~RUBY), compiled_method('__phlex_state__.buffer.<<("<h1></h1>")')
			def foo
				h1
			end
		RUBY
	end

	test "standard element with a static content block" do
		assert_equivalent_ruby compile(<<~RUBY), compiled_method('__phlex_state__.buffer.<<("<h1>Hello</h1>")')
			def foo
				h1 { "Hello" }
			end
		RUBY
	end

	test "void element with literal attributes is serialised at compile time" do
		assert_equivalent_ruby compile(<<~RUBY), compiled_method('__phlex_state__.buffer.<<("<img src=\"/a.png\">")')
			def foo
				img(src: "/a.png")
			end
		RUBY
	end

	test "adjacent elements are compacted into a single buffer write" do
		# This is what `Compactor` is for: two `<<` calls must collapse to one.
		assert_equivalent_ruby compile(<<~RUBY), compiled_method('__phlex_state__.buffer.<<("<h1></h1><h2></h2>")')
			def foo
				h1
				h2
			end
		RUBY
	end

	test "a method with nothing to optimise is not compiled" do
		assert_equal compile(<<~RUBY), nil
			def foo
				1 + 1
			end
		RUBY
	end
end
