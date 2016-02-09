require "svg_path"

module ApplicationHelper
  def roles_by_category
    RoleCategory.includes(:roles).shuffle
  end

  LIGHTNESS_BY_HUE = [38, 34, 25, 32, 45, 36]

  def summary_color(model)
    @hue_weights ||= [0] * 12
    hue_index = weighted_rand(@hue_weights.map { |x| 1 / (x + 0.2) })

    @hue_weights.map!.with_index do |weight, i|
      bucket_angle = (hue_index - i) * 2 * Math::PI / @hue_weights.length
      weight + (Math.cos(bucket_angle) + 1) ** 1.5
    end
    min_weight = @hue_weights.min
    @hue_weights.map!.with_index do |weight, i|
      weight - min_weight
    end

    hue = ((hue_index + rand) / @hue_weights.length * 360).to_i
    lightness = circular_interpolate(LIGHTNESS_BY_HUE, hue / 360.0 * LIGHTNESS_BY_HUE.length)

    "hsl(#{hue}, 40%, #{lightness}%)"
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

  def weighted_rand(array)
    x = Random.rand(array.sum)
    array.each.with_index do |weight, i|
      x -= weight
      return i if x <= 0
    end
    array.length - 1
  end

  def circular_interpolate(array, index)
    w = index % 1
    array[index] * (1-w) + array[(index + 1) % array.length] * w
  end

end
