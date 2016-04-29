class InvitationsController < ApplicationController

  # Require login, but ask to be redirected back here even for
  # newly created users.
  before_action -> { require_login(override_new_user_setup: true) }

  def accept
    invitation = ParticipantInvitation.find_by(invitation_code: params[:code])

    unless invitation
      flash[:notice] = "That invitation link is no longer valid. Perhaps you’ve already accepted it?"
      return redirect_to(edit_person_path(current_user, anchor: 'projects'))
    end

    invitation.accepted_by(current_user)

    flash[:success] = "You are now participating in #{invitation.project.name}."

    # Follow through on user setup if this is a newly created user;
    # other wise show the newly joined project.
    redirect_to pluck_login_redirect_url(
      default_url: invitation.project)
  end

end
