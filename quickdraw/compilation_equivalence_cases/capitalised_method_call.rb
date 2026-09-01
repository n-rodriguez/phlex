# frozen_string_literal: true

# `Phlex::Kit` defines a capitalised method per component, so `Widget()` is
# everywhere in a Kit-using codebase. Re-emitting it without its parentheses
# turns the call into a constant read: the component is never rendered, and the
# constant may even resolve, leaving no error behind.
class CapitalisedMethodCall < Phlex::HTML
	def view_template
		Widget()
		div { Widget() }
	end

	def Widget
		span(class: "widget") { "w" }
	end
end
