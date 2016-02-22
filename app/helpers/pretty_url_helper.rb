module PrettyUrlHelper

  def pretty_url(url)
    h(url)
      .gsub(%r_^https?://(www\.)?_, '')
      .gsub(%r_/$_, '')
      .gsub(%r_\Agithub\.com/_) { inline_icon_tag(:github) }
      .gsub(%r_\A..\.wikipedia\.org/wiki/(.*)_) { inline_icon_tag(:wikipedia) + "Definition" }
      .gsub(%r_\A(?!<span)_) { inline_icon_tag('generic-link') }
      .html_safe
  end

  def pretty_url_link(url)
    link_to pretty_url(url), url
  end

private

  def inline_icon_tag(name)
    span_tag('inline-icon', inline_icon(name))
  end

  def inline_icon(name)
    @inline_icons ||= Hash.new do |h,k|
      h[k] =
        File.read(
          File.join(Rails.root, 'app', 'assets', 'images', 'inline-icon', "#{k}.svg")
        ).html_safe
    end
    @inline_icons[name]
  end

end
