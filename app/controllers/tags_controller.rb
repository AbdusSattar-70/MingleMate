class TagsController < ApplicationController
  before_action :set_tag, only: %i[show update destroy]

  # GET /tags
  def index
    @tags = Tag.all.pluck(:name).flat_map { |tag| tag.split(/\s+/) }
    render json: @tags
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

  def tag_params
    params.require(:tag).permit(:name)
  end
end
