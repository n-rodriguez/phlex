# frozen_string_literal: true

# A block whose only statement is a method call that happens to share a name
# with an HTML element — `title`, `summary`, `map`, `select`, `time`… The call
# has a receiver, so it is not an element and the block's return value is the
# content. Deciding otherwise inlines the call as a statement and drops what it
# returned, leaving `<h1></h1>`.
class TagNamedMethodCall < Phlex::HTML
	def view_template
		h1(class: "text-primary") { record.title }
		h2 { record.summary }
		# Control: the outermost call is `join`, not the tag-named `map`, so this
		# one must keep working whichever way the predicate goes.
		div { [1, 2].map { |n| n.to_s }.join("-") }
	end

	def record
		# Anonymous, so re-requiring the file during compilation does not
		# redefine a constant.
		Struct.new(:title, :summary).new("Un titre", "Un résumé")
	end
end
