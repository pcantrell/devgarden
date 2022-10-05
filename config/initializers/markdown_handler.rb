# Based on http://stackoverflow.com/a/10131299/239816

module MarkdownHandler
  def self.erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def self.call(*args)
    compiled_source = erb.call(*args)
    "Kramdown::Document.new(begin;#{compiled_source};end).to_html"
  end
end

ActionView::Template.register_template_handler :md, MarkdownHandler
