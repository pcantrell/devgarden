module Themed
  extend ActiveSupport::Concern

  included do
    before_save :sanitize_theme
  end

private

  def sanitize_theme
    return unless theme_changed?

    sanitized_theme = {}

    %w(primary_hue highlight_hue).each do |hue_key|
      sanitized_theme[hue_key] =
        (Float(theme[hue_key]) % 360 + 360) % 360 rescue nil
    end

    self.theme = sanitized_theme
  end
end
