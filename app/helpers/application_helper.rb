module ApplicationHelper
  def roles_by_category
    RoleCategory.includes(:roles).shuffle
  end

  def summary_style(model)
    @hue_weights ||= [0] * 12
    hue_index = weighted_rand(@hue_weights.map { |x| 1 / (x + 1) })

    @hue_weights.map!.with_index do |weight, i|
      bucket_angle = (hue_index - i) * 2 * Math::PI / @hue_weights.length
      weight + (Math.cos(bucket_angle) + 1) ** 1.5
    end
    min_weight = @hue_weights.min
    @hue_weights.map!.with_index do |weight, i|
      weight - min_weight
    end

    hue = ((hue_index + rand) / @hue_weights.length * 360).to_i

    "background: hsl(#{hue}, 75%, 40%);"
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

end
