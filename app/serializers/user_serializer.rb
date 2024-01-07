class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :user_name, :role, :blocked, :avatar, :created_at
end
