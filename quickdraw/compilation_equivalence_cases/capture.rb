# frozen_string_literal: true

class Capture < Phlex::HTML
	def view_template
		# `capture` swaps the state's buffer for the duration of the block, so a
		# compiled write aimed at the original buffer escapes the capture.
		captured = capture { div { "hi" } }
		h1 { captured }
	end
end
