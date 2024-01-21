class ItemSerializer
  def self.serialize(item, for_pg_search = false)
    if for_pg_search
      serialize_for_pg_search(item)
    else
      serialize_regular(item)
    end
  end

  def self.serialize_regular(item)
    {
      item_id: item.id,
      item_name: item.item_name,
      collection_name: item.collection&.title,
      collection_id: item.collection&.id,
      item_author: item.user&.user_name,
      author_id: item.user&.id,
      tags: serialize_tags(item&.tags),
      item_custom_fields: serialize_custom_fields(item.custom_fields),
      likes: serialize_likes(item&.likes),
      comments: serialize_comments(item.comments)
    }
  end

  def self.serialize_for_pg_search(item)
    {
      item_id: item.id,
      item_name: item.item_name,
      collection_name: item.collection&.title,
      collection_des: item.collection&.description,
      item_author: item.user&.user_name,
      likes_count: item.likes.count,
      comments_count: item.comments.count,
      comments_content: item.comments.map(&:content).join(', '),
      created_at: item.created_at,
      updated_at: item.updated_at
    }
  end

  def self.serialize_tags(tags)
    tags.pluck(:name).flat_map { |tag| tag.split(/\s+/) }
  end

  def self.serialize_custom_fields(custom_fields)
    custom_fields.map do |field|
      {
        id: field['id'],
        field_name: field['field_name'],
        field_type: field['field_type'],
        field_value: field['field_value']
      }
    end
  end

  def self.serialize_comments(comments)
    comments.map do |comment|
      {
        comment_id: comment.id,
        content: comment.content,
        commenter_name: comment.user&.user_name,
        commenter_avatar: comment.user&.avatar,
        commenter_id: comment.user_id,
        created_at: comment.created_at,
        updated_at: comment.updated_at
      }
    end
  end

  def self.serialize_likes(likes)
    likes.map do |like|
      {
        id: like.id,
        user_id: like.user_id,
        user_name: like.user&.user_name,
        user_photo: like.user&.avatar
      }
    end
  end
end
