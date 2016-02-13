require "svg_path"

module DatesHelper

  def format_time_range(
      start_time,
      end_time = nil,
      format = default_time_range_format,
      separator = span_tag(:separator, "–"))

    merged = if end_time
      merge_identical_levels(
        recursive_format(start_time, format),
        recursive_format(end_time, format),
        separator)
    else
      recursive_format(start_time, format)
    end

    merged.flatten.join.html_safe
  end

  def default_time_range_format
    @default_time_range_format ||= IceNine.deep_freeze(
      [
        "<span class='daterange'>",
        span_tag(:weekday, "%a "),
        span_tag(:monthday, "%b %-d, "),
        [
          [
            span_tag(:hourmin, "%-l:%M")
          ],
          span_tag(:ampm, "%p")
        ],
        "</span>"
      ]
    )
  end

private

  def recursive_format(time, format)
    format.map do |val|
      if val.is_a?(String)
        time.strftime(val)
      else
        recursive_format(time, val)
      end
    end
  end

  def merge_identical_levels(vals0, vals1, separator)
    cur_level0, cur_level1 = [vals0, vals1].map do |tf|
      tf.select { |val| val.is_a?(String) }
    end
    if cur_level0 != cur_level1
      vals0 + [separator] + vals1
    else
      vals0.zip(vals1).map do |val0, val1|
        if val0.is_a?(String)
          val0
        else
          merge_identical_levels(val0, val1, separator)
        end
      end
    end
  end

end
