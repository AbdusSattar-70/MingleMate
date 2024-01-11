class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      # Check if this is the first user provide admin privilege
      current_user.update(role: 2) if User.count == 1
            render json: { message: 'Successfully Signed In', data: serialized_user_attributes(current_user) }
    else
      render json: { message: "Registration failed. #{current_user.errors.full_messages.to_sentence}" },
             status: :unprocessable_entity
    end
  end

   def serialized_user_attributes(resource)
    UserSerializer.new(resource).serializable_hash[:data][:attributes]
  end
end
