class UsersController < ApplicationController
  before_action :set_user, only: %w[show destroy]

  def index
    @users = if params[:search].present?
      User.search(params.dig(:search, :filter))
    else
      User.all
    end

    @pagy, @users = pagy(@users) if @users.present?
  end

  def show
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
