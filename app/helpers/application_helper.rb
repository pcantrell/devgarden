module ApplicationHelper

  include CurrentUserHelper

  def roles_by_category
    RoleCategory.includes(:roles).shuffle
  end

  def upcoming_events(min_events:, including_all_within:, limit: 20)
    time_limit = including_all_within.from_now
    EventDate.future.limit(limit)
      .each.with_index
      .take_while { |d, i| i < min_events || d.start_time < time_limit }
      .map { |d,i| d }
      .slice_when { |d0, d1| d0.event != d1.event }
      .each { |dates| yield dates.first.event, dates }
  end

  def heading_level
    @heading_level ||= (params[:heading_level] || 1).to_i
  end

  def heading(title, **tag_attrs, &block)
    @first_heading_on_page ||= title
    haml_tag("h#{heading_level}", title, **tag_attrs)
    with_next_heading_level(&block) if block
  end

  def with_next_heading_level(&block)
    @heading_level += 1
    begin
      yield
      ""
    ensure
      @heading_level -= 1
    end
  end

  def page_title
    return @custom_page_title if @custom_page_title

    title = @first_heading_on_page ||
      (params[:id] || controller_name).humanize.capitalize
    "Dev Garden – #{title}"
  end

  def span_tag(css_class, text)
    content_tag(:span, text, class: css_class)
  end

  def markdown(md)
    Kramdown::Document.new(md, header_offset: heading_level - 1).to_html.html_safe
  end

  def first_paragraph_of_markdown(md)
    $1 if md =~ %r{
      \A            # At the start of the document,
      (?:\s|^\#.*)* # any amount of whitespace & headings, then
      
      (.+?)         # the shortest string of chars followed by

      (?:           # a paragraph break or document boundary
        \r\n\r\n
        |\n\n
        |$
      )
    }xm
  end

end
