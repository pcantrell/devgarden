module ChangeNotifying
  extend ActiveSupport::Concern

  included do
  end

  def notification_attributes
    attributes
      .reject { |k,v| k == 'updated_at' }
      .merge(custom_notification_attributes)
  end

  def custom_notification_attributes
    {}
  end

end
