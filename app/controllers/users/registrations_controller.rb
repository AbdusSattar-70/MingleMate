class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      # Check if this is the first user provide admin privilege
      current_user.update(role: 2) if User.count == 1
      render json: { message: 'Signed up successfully.' }, status: :ok
    else
      render json: { message: "Registration failed. #{current_user.errors.full_messages.to_sentence}" },
             status: :unprocessable_entity
    end
  end
end
