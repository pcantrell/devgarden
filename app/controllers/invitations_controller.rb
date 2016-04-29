class InvitationsController < ApplicationController

  before_action :require_login

  def accept
    invitation = ParticipantInvitation.find_by(invitation_code: params[:code])

    unless invitation
      flash[:notice] = "That invitation link is no longer valid. Perhaps you’ve already accepted it?"
      return redirect_to(edit_person_path(current_user, anchor: 'projects'))
    end

    invitation.accepted_by(current_user)

    flash[:success] = "You are now participating in #{invitation.project.name}."
    redirect_to invitation.project
  end

end
