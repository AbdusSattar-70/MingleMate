class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show update destroy]

  # GET /collections
  def index
    @collections = Collection.all
    render json: @collections
  end

  # GET /collections/1
  def show
    render json: @collection
  end

  # POST /collections
  def create
    @collection = Collection.new(collection_params.except(:categories))
    create_or_delete_collection_category(@collection, params[:collection][:categories])

    if @collection.save
      render json: @collection, status: :created
    else
      render json: { errors: @collection.errors }, status: :unprocessable_entity
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
    @collection = Collection.find(params[:id])
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
                                       custom_fields: %i[field_name field_type])
  end
end
