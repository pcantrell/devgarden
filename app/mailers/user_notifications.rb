class UserNotifications < ApplicationMailer
  default from: "pcantrel@macalester.edu"

  def participant_invitation(invitation)
    @invitation = invitation
    mail to: invitation.email,
         subject: "Did you work on #{invitation.project.name}?"
  end
end
