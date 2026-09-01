# frozen_string_literal: true

class ModifierIf < Phlex::HTML
	# An element under a modifier `if` expands into several buffer writes. The
	# modifier has to guard all of them: guarding only the last one emits the
	# opening tag unconditionally and runs the content — side effects included —
	# when the condition is false.
	def self.equivalence_args
		[[true], [false]]
	end

	def initialize(flag)
		@flag = flag
	end

	def view_template
		b { "always" }
		# Contenu non littéral : le Compactor ne peut pas fondre l'élément en une
		# seule écriture, donc il s'expanse bien en plusieurs instructions.
		span(class: "x") { plain content } if @flag
		i { "end" }
	end

	def content
		"content"
	end
end
