# for general user purpose
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[update destroy]

  # GET /users/id single user
  def show
    render json: serialized_user_attributes(@user)
  end

  def update
    if @user.update(user_params)
      render json: { message: 'Successfully Signed In', data: serialized_user_attributes(@user) }

    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def serialized_user_attributes(resource)
    UserSerializer.new(resource).serializable_hash[:data][:attributes]
  end

  def user_params
    params.require(:user).permit(:user_name, :email, :avatar, :password, :bio, :profession)
  end
end
