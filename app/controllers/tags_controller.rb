class TagsController < ApplicationController
  before_action :set_tag, only: %i[show update destroy]

  # GET /tags
   def index
    all_tags = Tag.all.pluck(:name).flat_map { |tag| tag.split(/\s+/) }
    unique_tags = all_tags.uniq

    render json: unique_tags
  end

  def tag_related_items
    if params[:search].present?
      search_term = params[:search].downcase
      @tags = Tag.where('LOWER(name) LIKE ?', "%#{search_term}%")

      @related_items = @tags.flat_map(&:items)
    else
      @related_items = Item.all
    end

    render json: serialize_items(@related_items)
  end

  # GET /tags/1
  def show
    render json: @tag
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      render json: @tag, status: :created
    else
      render json: { errors: @tag.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      render json: @tag, status: :ok
    else
      render json: { errors: @tag.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy!
    render json: { message: 'Tag deleted successfully' }
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def serialize_items(items)
    items.map { |item| serialize_item(item) }
  end

  def serialize_item(item)
    {
      item_id: item.id,
      item_name: item.item_name,
      collection_name: item.collection&.title,
      item_author: item.user&.user_name,
      likes: item.likes.count,
      comments: item.comments.count,
      created_at: item.created_at,
      updated_at: item.updated_at
    }
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
