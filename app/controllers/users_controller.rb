class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def show
    @user = User.find(params[:id])
    @organized_events = @user.organized_events.order(start_date: :asc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profil mis à jour avec succès !"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, alert: "Accès non autorisé." unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :description)
  end
end
