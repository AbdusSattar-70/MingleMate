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
    # Pass true to indicate pg_search serialization
    render json: serialize_items(@items, true)
  end

  def collection_items
    sorted_request = params[:sort_by]
    sorted_items = ItemSortingService.apply_sort_items(@items, sorted_request)
    render json: serialize_items(sorted_items)
  end

  def user_items
    render json: serialize_items(@items)
  end

  def show
    render json: ItemSerializer.serialize(@item)
  end

  def create
    @item = Item.new(item_params.except(:tags))
    create_or_delete_item_tag(@item, params[:item][:tags])

    if @item.save
      render json: ItemSerializer.serialize(@item), status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def update
    create_or_delete_item_tag(@item, params[:item][:tags])

    if @item.update(item_params.except(:tags))
      render json: ItemSerializer.serialize(@item), status: :ok, location: @item
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
               Item.where(collection_id:)
             elsif user_id.present?
               paginate_items(Item.where(user_id:))
             else
               paginate_items(Item.all)
             end
  end

  def paginate_and_sort_items(items, sorted_request = nil)
    sorted_items = ItemSortingService.apply_sort_items(items, sorted_request)
    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 5).to_i
    sorted_items.includes(common_includes).limit(per_page).offset((page - 1) * per_page)
  end

  def common_includes
    %i[collection user tags likes comments]
  end

  def serialize_items(items, for_pg_search = false)
    items.map { |item| ItemSerializer.serialize(item, for_pg_search) }
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
