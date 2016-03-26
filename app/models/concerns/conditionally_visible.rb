module ConditionallyVisible
  extend ActiveSupport::Concern

  included do
    scope :visible, -> { where(visible: true) }
  end
end
