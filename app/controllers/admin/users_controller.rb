class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params)
    @user.admin = params.dig(:user, :admin) == "1"
    if @user.save
      redirect_to admin_user_path(@user), notice: "Utilisateur mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "Vous ne pouvez pas supprimer votre propre compte."
    else
      @user.destroy
      redirect_to admin_users_path, notice: "Utilisateur supprimé."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :description)
  end
end
