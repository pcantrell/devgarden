class JobReport < ApplicationRecord
  belongs_to :owner, class_name: 'Person'

  def completed?
    !!(error || results)
  end
end
