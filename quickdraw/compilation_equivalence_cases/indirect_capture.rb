# frozen_string_literal: true

class IndirectCapture < Phlex::HTML
	def view_template
		# `capture` does not appear here — `wrapper` is the one calling it. The
		# block is still inlined into this method, so a guard looking for the
		# name `capture` in this body would see nothing.
		captured = wrapper { div { "hi" } }
		h1 { captured }
	end

	def wrapper(&block)
		capture(&block)
	end
end
