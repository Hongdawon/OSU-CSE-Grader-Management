class HomeController < ApplicationController
  def index
      # Load all users to display in the view
      @users = User.where(approved: false, role: ["Instructor", "Admin"])
  end

  def approve
    user = User.find(params[:id])
    user.approve
    redirect_to root_path, notice: "User approved successfully."
  end
end
