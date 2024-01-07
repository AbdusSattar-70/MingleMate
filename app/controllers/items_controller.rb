class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]

  def collection_items
    collection_id = params[:collection_id]

    if collection_id.present?
      @items = Item.where(collection_id:)
      render json: serialize_items(@items)
    else
      render json: { error: 'Missing collection_id parameter' }, status: :unprocessable_entity
    end
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
    @item.destroy!
    head :no_content
  end

  private

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

  def serialize_items(items)
    items.map { |item| serialize_item(item) }
  end

  def serialize_item(item)
    {
      id: item.id,
      item_name: item.item_name,
      item_author: item.user&.user_name,
      tags: item.tags.pluck(:name).flat_map { |tag| tag.split(/\s+/) },
      item_custom_fields: item.custom_fields.map { |field| serialize_custom_field(field) },
      likes: item.likes.count,
      comments_count: item.comments.count,
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
      id: comment.id,
      content: comment.content,
      user_name: comment.user&.user_name
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
