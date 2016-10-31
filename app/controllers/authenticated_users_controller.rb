class AuthenticatedUsersController < ApplicationController
  def create
    avatars = params[:fitbit_user][:avatars].permit!.to_h

    remote_id = params[:fitbit_user][:remote_id]

    fitbit_user_params = params.require(:fitbit_user).permit(
      :display_name,
      :full_name,
      :timezone
    ).merge(avatars: avatars)

    @fitbit_user = FitbitUser.find_or_initialize_by(remote_id: remote_id) do |user|
      user.attributes = fitbit_user_params
    end

    @authenticated_user = @fitbit_user.authenticated_user || @fitbit_user.build_authenticated_user

    @authenticated_user.attributes = params.require(:authenticated_user).permit(:access_token, :refresh_token, watching: [])

    ActiveRecord::Base.transaction do
      @fitbit_user.save!
      @authenticated_user.save!
    end

    render text: 'Got it! Check back later.'
  end
end
