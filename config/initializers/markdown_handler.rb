# Based on http://stackoverflow.com/a/10131299/239816

# require 'kramdown'

module MarkdownHandler
  def self.erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def self.call(template)
    compiled_source = erb.call(template)
    "Kramdown::Document.new(begin;#{compiled_source};end).to_html"
  end
end

ActionView::Template.register_template_handler :md, MarkdownHandler
