module ApplicationHelper

  include CurrentUserHelper

  def roles_by_category
    RoleCategory.includes(:roles).shuffle
  end

  def upcoming_events(min_events:, including_all_within:, limit: 20)
    time_limit = including_all_within.from_now
    EventDate.future.limit(limit)
      .each.with_index
      .take_while { |date, index| index < min_events || date.start_time < time_limit }
      .map { |date, _| date }
      .slice_when { |date0, date1| date0.event != date1.event }
      .each { |dates| yield dates.first.event, dates }
  end

  def heading_level
    @heading_level ||= (params[:heading_level] || 1).to_i
  end

  def heading(title, **tag_attrs, &block)
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
    @page_title ||= begin
      heading = first_heading(content_for(:layout))
      title = if heading
        strip_tags(heading).strip.gsub(/\s+/, ' ')
      else
        controller_name.humanize.capitalize
      end
      "Dev Garden – #{title}"
    end
  end

  def first_heading(html)
    $1 if html =~ %r{
      <h1 [^>]* >   # Opening tag, with optional attrs
        (.*?)       # Tag content
      </h1>         # Closing tag
    }xm
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
