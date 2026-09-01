# frozen_string_literal: true

class IndirectCapture < Phlex::HTML
	def view_template
		# `capture` n'apparaît pas ici : c'est `wrapper` qui l'appelle. Le bloc
		# est pourtant inliné dans cette méthode, donc un garde portant sur le
		# nom `capture` dans ce corps ne verrait rien.
		captured = wrapper { div { "hi" } }
		h1 { captured }
	end

	def wrapper(&block)
		capture(&block)
	end
end
