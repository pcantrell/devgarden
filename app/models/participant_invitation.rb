class ParticipantInvitation < ApplicationRecord
  belongs_to :project
  belongs_to :created_by, class_name: 'Person'

  validates :name, :email, presence: true

  before_save do
    self.invitation_code ||= SecureRandom.urlsafe_base64(24)
  end

  def accepted_by(person)
    Project.transaction do
      participation = project.participations.find_or_initialize_by(person: person)
      participation.admin ||= admin
      participation.save!
      destroy
    end
  end
end
