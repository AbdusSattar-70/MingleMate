class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :user_name,:profession,:bio, :role, :blocked, :avatar, :updated_at

  attribute :items_count do |user|
    user.items.count
  end

  attribute :collections_count do |user|
    user.collections.count
  end
end
