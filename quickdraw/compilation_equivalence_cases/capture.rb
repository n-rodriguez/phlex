# frozen_string_literal: true

class Capture < Phlex::HTML
	def view_template
		# `capture` remplace le tampon de l'état le temps du bloc : une écriture
		# compilée qui viserait le tampon d'origine sortirait de la capture.
		captured = capture { div { "hi" } }
		h1 { captured }
	end
end
