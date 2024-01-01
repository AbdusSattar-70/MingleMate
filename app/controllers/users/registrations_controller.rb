class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params
  include RackSessionFix
  respond_to :json

  # POST /signup
  def create
      @user = User.new(user_params)

      if @user.save
        render json: {message: 'User Created Successfully!'}, status: :ok
      else
        render json: { message: "Unable to Create: #{@user.errors.full_messages}"}, status: :unprocessable_entity
      end
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :email, :password])
  end

  def user_params
    params.require(:user).permit(:user_name, :email, :password)
  end

end