class ParticipantInvitation < ApplicationRecord
  belongs_to :project
  belongs_to :created_by, class_name: 'Person'

  validates :name, :email, presence: true

  before_save do
    self.invitation_code ||= SecureRandom.urlsafe_base64(24)
  end
end
