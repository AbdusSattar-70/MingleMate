class AdminDashboardController < ApplicationController
  before_action :set_users, only: [:index]
  before_action :authenticate_user!

  # GET /users
  def index
    users = @users.map { |user| serialized_user_attributes(user) }
    render json: users
  end

  def block_multiple
    handle_multiple_action(true, 'Blocked succeeded', 'Failed to block')
  end

  def unblock_multiple
    handle_multiple_action(false, 'Unblocked succeeded', 'Failed to unblock')
  end

  def destroy_multiple
    handle_multiple_action(nil, 'Delete succeeded', 'Failed to delete')
  end

  def assign_admin_role_multiple
    handle_role_action(2, 'Admin role assigned successfully', 'Failed to assign admin role')
  end

  def remove_from_admin_multiple
    handle_role_action(1, 'Removed from admin role successfully', 'Failed to remove from admin role')
  end

  private

  def set_users
    @users = User.all

    # Filter by role
    @users = @users.where(role: params[:role]) if params[:role].present?

    # Filter by status
    @users = @users.where(blocked: params[:blocked]) if params[:blocked].present?
    # Default ordering if no parameter is provided
    @users = @users.order(:id)
  end

  def handle_multiple_action(blocked, success_message, failure_message)
    user_emails = params[:user_emails]
    users = User.where(email: user_emails)

    if blocked.nil? ? users.destroy_all : users.update_all(blocked:)
      render json: { message: success_message }, status: :ok
    else
      render json: { message: failure_message }, status: :unprocessable_entity
    end
  end

  def handle_role_action(new_role, success_message, failure_message)
    user_emails = params[:user_emails]
    users = User.where(email: user_emails)

    if users.update_all(role: new_role)
      render json: { message: success_message }, status: :ok
    else
      render json: { message: failure_message }, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:email, :role, :blocked, user_emails: [])
  end

  def serialized_user_attributes(resource)
    UserSerializer.new(resource).serializable_hash[:data][:attributes]
  end
end
