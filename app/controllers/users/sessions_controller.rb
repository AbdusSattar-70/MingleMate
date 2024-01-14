class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json

  def create
    @user = authenticate_user

    if @user && @user&.valid_password?(sign_in_params[:password])
      if @user.blocked == true
        render json: { message: 'Oops! You were blocked by admin' }, status: :unauthorized
      else
        sign_in(:user, @user)
        render json: { message: 'Successfully Signed In', data: serialized_user_attributes(@user) }, status: :ok
      end
    else
      render_unauthorized
    end
  end

  protected

  def respond_to_on_destroy
    decode_jwt
    if current_user
      sign_out(current_user)
      render json: { message: 'Signed Out Successfully!' }, status: :ok
    else
      render_unauthorized
    end
  end

  def authenticate_user
    User.find_for_database_authentication(email: sign_in_params[:email])
  end

  def render_unauthorized
    render json: { message: 'Unauthorized' }, status: :unauthorized
  end

  def decode_jwt
    return unless request.headers['Authorization'].present?

    begin
      jwt_payload = JWT.decode(request.headers['Authorization']&.split()&.last,
                               Rails.application.credentials.devise_jwt_secret_key!)&.first
      User.find(jwt_payload['sub'])
    rescue StandardError
      nil
    end
  end

  def serialized_user_attributes(resource)
    UserSerializer.new(resource).serializable_hash[:data][:attributes]
  end
end
