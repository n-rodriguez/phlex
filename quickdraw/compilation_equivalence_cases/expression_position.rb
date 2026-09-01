# frozen_string_literal: true

class ExpressionPosition < Phlex::HTML
	# An element expands into several statements — opening tag, content, closing
	# tag — so it can only be rewritten where a statement is expected. Rewritten
	# as the value of a `return`, only the opening tag is returned and the rest
	# never runs: the tag is left unclosed and the content disappears.
	def self.equivalence_args
		[[%w[a b c]]]
	end

	def initialize(items)
		@items = items
	end

	def view_template
		ol(class: "breadcrumb") { @items.each { |item| crumb(item) } }
		p { assigned }
	end

	private

	def crumb(item)
		return li(class: "crumb") { plain "link-#{item}" } unless last?(item)

		li(class: "crumb active") { plain item }
	end

	# The same rule for an assignment: the element is a value here, not a
	# statement, so it has to be left alone too.
	def assigned
		captured = capture { span { "x" } }
		captured.length.to_s
	end

	def last?(item)
		@items.last == item
	end
end
