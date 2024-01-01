class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  before_action :configure_sign_in_params, only: [:create]
  respond_to :json

  def create
    @user = authenticate_user

    if @user
      sign_in_user
      render_successful_sign_in
    else
      render_unauthorized
    end
  end

  protected

  def respond_to_on_destroy
    handle_user_sign_out
  rescue JWT::DecodeError
    render_unauthorized
  end

  def configure_sign_in_params
    params.require(:user).permit(:email, :password)
  end

  def authenticate_user
    User.find_for_database_authentication(email: sign_in_params[:email])
  end

  def sign_in_user
    sign_in(:user, @user)
  end

  def render_successful_sign_in
    jwt_token = JWT.encode({ sub: @user.id }, Rails.application.credentials.fetch(:secret_key_base))
    render json: { message: 'Successfully Signed In', data: serialized_user_attributes(@user) }
  end

  def render_unauthorized
    render json: { message: 'Unauthorized' }, status: :unauthorized
  end

  def handle_user_sign_out
    jwt_token = request.headers['Authorization']&.split(' ')&.last

    if jwt_token
      jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.fetch(:secret_key_base)).first
      user_id = jwt_payload['sub']
      current_user = User.find_by(id: user_id)

      if current_user
        sign_out(current_user)
        render json: { message: 'User Signed Out Successfully!' }, status: :ok
      else
        render_unauthorized
      end
    else
      render_unauthorized
    end
  end

  def serialized_user_attributes(resource)
    UserSerializer.new(resource).serializable_hash[:data][:attributes]
  end
end
