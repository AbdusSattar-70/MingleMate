class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show update destroy]

  # GET /collections
  def index
     @collections = Collection.includes(:user, :categories).all
    render json: serialize_collections(@collections)
  end

  # GET /collections/top_five
   def top_five
    @collections = Collection
      .joins(:items)
      .group('collections.id')
      .order('COUNT(items.id) DESC')
      .limit(5)
      .includes(:user, :categories, :items)
    render json: serialize_collections(@collections)
  end

  # GET /collections/1
  def show
    render json: serialize_collection(@collection)
  end

  # GET /get_collection_custom_fields/1
  def get_collection_custom_fields
  @collection = Collection.find(params[:id])
    render json: serialize_collection_for_item_add(@collection)
  end

  # POST /collections
  def create
    @collection = Collection.new(collection_params.except(:categories))
    create_or_delete_collection_category(@collection, params[:collection][:categories])

    if @collection.save
      render  status: :created
    else
      render json: { message: @collection.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /collections/1
  def update
    create_or_delete_collection_category(@collection, params[:collection][:categories])

    if @collection.update(collection_params.except(:categories))
      render json: @collection
    else
      render json: @collection.errors, status: :unprocessable_entity
    end
  end

  # DELETE /collections/1
  def destroy
    @collection.destroy!
    head :no_content
  end

  private

  def set_collection
  @collection = Collection.includes(:user, :categories).find(params[:id])
  end


  def create_or_delete_collection_category(collection, categories)
    collection.categorizables.destroy_all
    categories = categories.strip.split(',')

    categories.each do |category|
      collection.categories << Category.find_or_create_by(name: category)
    end
  end

  def collection_params
    params.require(:collection).permit(:title, :description, :image, :user_id, :categories,
                                       custom_fields: %i[id field_name field_type])
  end

  def serialize_collections(collections)
    collections.map do |collection|
       {
      id: collection.id,
      title: collection.title,
      description: collection.description,
      image: collection.image,
      category:collection.categories.first.name,
      user_name: collection.user.user_name,
      items_count: collection.items.count,
    }
    end
  end

  def serialize_collection(collection)
    {
      id: collection.id,
      title: collection.title,
      description: collection.description,
      image: collection.image,
      category:collection.categories.first.name,
      user_name: collection.user.user_name,
      items_count: collection.items.count,
    }
  end



   def serialize_collection_for_item_add(collection)
    {
      title: collection.title,
      image: collection.image,
      custom_fields: collection.custom_fields,
      tags: serialize_tags(Tag.all)
    }
  end

  def serialize_tags(tags)
    tags.pluck(:name).flat_map { |tag| tag.split(/\s+/) }
  end

end
