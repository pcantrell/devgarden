require "svg_path"

module DesignElementsHelper

  def theme_color(model, role)
    hue_key = case role
      when :featured_text,
           :button_background
        :highlight_hue
      else
        :primary_hue
    end

    hue = theme_value(model, hue_key) || default_hue(model)
    theme_color_by_hue(hue, role)
  end

  def theme_color_by_hue(hue, role)
    saturation = 60
    lightness = circular_interpolate(LIGHTNESS_BY_HUE, hue / 360.0 * LIGHTNESS_BY_HUE.length)

    case role
      when :featured_text
      when :body_text
        lightness /= 1.5
      when :background
        saturation -= 10
      when :button_background
        saturation += 30
      else
        raise "Unknown feature color role: #{role.inspect}"
    end

    [hue.round, saturation.round, lightness.round]
  end

  def bend_percentage(percent, gamma)
    (percent / 100.0) ** gamma * 100.0
  end

  def hue_lookup_table(role)
    (0...360).map do |hue|
      theme_color_by_hue(hue, role)
    end
  end

  def theme_style(model, role)
    h,s,l = theme_color(model, role)
    color = "hsl(#{h}, #{s}%, #{l}%)"
    lighter = "hsl(#{h}, #{bend_percentage(s, 0.6)}%, #{bend_percentage(l, 0.3)}%)"
    darker = "hsl(#{h}, #{bend_percentage(s, 0.2)}%, #{bend_percentage(l, 2.0)}%)"
    case role
      when :featured_text,
           :body_text
        "color: light-dark(#{color}, #{lighter})"
      when :background
        "background: light-dark(#{color}, #{darker})"
      when :button_background
        "background: light-dark(#{color}, #{lighter})"
    end
  end

  def project_divider_path(npts = 2)
    path = SVGPath.new

    def randsign
      rand(2) * 2 - 1
    end

    x0, y0 = 0, rand(-0.5..0.5)
    x1, y1 = rand(0.1..0.5), 1 * randsign
    x2, y2 = rand(0.5..0.9), 1 * randsign
    x3, y3 = 1, rand(-0.5..0.5)
    ally = [y0, y1, y2, y3]
    ymid = (ally.min + ally.max) / 2

    thickness = 0.1

    path.move_to(x0, y0 - ymid)
    path.cubic_to(
      x1, y1 + thickness - ymid,
      x2, y2 + thickness - ymid,
      x3, y3 - ymid)
    path.cubic_to(
      x2, y2 - thickness - ymid,
      x1, y1 - thickness - ymid,
      x0, y0 - ymid)
    path.close

    path.to_s
  end

private

  LIGHTNESS_BY_HUE = [38, 34, 37, 32, 49, 36]
  GOLDEN_ANGLE = 180 * (3 - Math.sqrt(5))

  def theme_value(model, key)
    model.theme[key.to_s] rescue nil
  end

  def default_hue(model)
    ((model.id - 1) * GOLDEN_ANGLE + 243) % 360
  end

  def circular_interpolate(array, index)
    w = index % 1
    array[index] * (1-w) + array[(index + 1) % array.length] * w
  end

end
