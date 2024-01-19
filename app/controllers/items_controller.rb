class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_items, only: %i[index collection_items user_items]
  before_action :authenticate_user!, only: %i[create update destroy]

  def index
    render json: serialize_items(@items)
  end

  def full_text_search
    search_param = params[:search]
    @items = Item.search(search_param)
    render json: serialize_items_for_pg_search(@items)
  end

  def collection_items
    render json: serialize_items(@items)
  end

  def user_items
    render json: serialize_items(@items)
  end

  def show
    render json: serialize_item(@item)
  end

  def create
    @item = Item.new(item_params.except(:tags))
    create_or_delete_item_tag(@item, params[:item][:tags])

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def update
    create_or_delete_item_tag(@item, params[:item][:tags])

    if @item.update(item_params.except(:tags))
      render json: @item, status: :ok, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      render json: { message: 'item deleted successfully', item_id: @item.id }, status: :ok
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

def apply_sort_items(items, items_sorting)
  case items_sorting
  when 'asc'
    items.order(created_at: :asc)
  when 'desc'
    items.order(created_at: :desc)
  when 'most_liked'
    items
      .joins(:likes)
      .group('items.id')
      .order('COUNT(likes.id) DESC')
  when 'most_commented'
    items
      .joins(:comments)
      .group('items.id')
      .order('COUNT(comments.id) DESC')
  else
    # Default to sorting by creation date in descending order
    items.order(created_at: :desc)
  end
end



  def create_or_delete_item_tag(item, tags)
    item.taggables.destroy_all
    tags = tags.strip.split(',')

    tags&.each do |tag|
      item.tags << Tag.find_or_create_by(name: tag)
    end
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_items
  collection_id = params[:collection_id]
  user_id = params[:user_id]

  @items = if collection_id.present?
             paginate_and_sort_items(Item.where(collection_id: collection_id))

           elsif user_id.present?
             paginate_and_sort_items(Item.where(user_id: user_id))

           else
             paginate_and_sort_items(Item.all)
           end
end

  def paginate_items(items)
    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 5).to_i
    items.includes(common_includes).order(created_at: :desc).limit(per_page).offset((page - 1) * per_page)
  end

  def paginate_and_sort_items(items)
  items_sorting = params[:sort_by]
  apply_sort_items(items, items_sorting) if items_sorting.present?
  paginate_items(items)
end

  def common_includes
    %i[collection user tags likes comments]
  end

  def serialize_items(items)
    items.map { |item| serialize_item(item) }
  end

  def serialize_item(item)
    {
      item_id: item.id,
      item_name: item.item_name,
      collection_name: item.collection&.title,
      collection_id: item.collection.id,
      item_author: item.user&.user_name,
      tags: item.tags.pluck(:name).flat_map { |tag| tag.split(/\s+/) },
      item_custom_fields: item.custom_fields.map { |field| serialize_custom_field(field) },
      likes: item.likes.map { |like| serialize_like(like) },
      comments: item.comments.map { |comment| serialize_comment(comment) }
    }
  end

  def serialize_custom_field(field)
    {
      id: field['id'],
      field_name: field['field_name'],
      field_type: field['field_type'],
      field_value: field['field_value']
    }
  end

  def serialize_comment(comment)
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

  def serialize_like(like)
    {
      id: like.id,
      user_id: like.user_id,
      user_name: like.user&.user_name,
      user_photo: like.user&.avatar
    }
  end

  # for pg search get rid of unused attr.
  def serialize_items_for_pg_search(items)
    items.map { |item| serialize_item_for_pg_search(item) }
  end

  def serialize_item_for_pg_search(item)
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

  def item_params
    params.require(:item).permit(
      :item_name,
      :collection_id,
      :user_id,
      :tags,
      custom_fields: %i[id field_name field_type field_value]
    )
  end
end
