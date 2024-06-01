class UsersController < ApplicationController

  def index
    @users = if params[:search].present?
      User.search(params.dig(:search, :filter))
    else
      User.all
    end

    @pagy, @users = pagy(@users) if @users.present?
  end

  def show
  end

end
