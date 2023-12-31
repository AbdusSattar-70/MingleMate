class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :user_name, :role, :blocked, :created_at
end
