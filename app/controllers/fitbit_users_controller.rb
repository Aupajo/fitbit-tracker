class FitbitUsersController < ApplicationController
  def index
    @fitbit_users = FitbitUser.all.sort_by do |user|
      user.readings.last.monthly_steps
    end.reverse
  end

  def show
    @fitbit_user = FitbitUser.find(params[:id])
  end
end
