class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    render :index
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Accès réservé aux administrateurs." unless current_user.admin?
  end
end
