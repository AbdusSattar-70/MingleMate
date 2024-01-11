class LikesController < ApplicationController
  before_action :set_like, only: %i[show update destroy]

  # GET /likes
  def index
    @likes = Like.all
    render json: @likes
  end

  # GET /likes/1
  def show
    render json: @like
  end

 # POST /likes
def create
  # Check if the user has already liked the item
  existing_like = Like.find_by(user_id: like_params[:user_id], item_id: like_params[:item_id])

  if existing_like
    # User has already liked the item, perform "unlike" action
    existing_like.destroy!
    head :no_content
  else
    # User hasn't liked the item, create a new "like"
    @like = Like.new(like_params)

    if @like.save
      render json: @like, status: :created, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end
end


  # PATCH/PUT /likes/1
  def update
    if @like.update(like_params)
      render json: @like, status: :ok, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy!
    head :no_content
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:user_id, :item_id)
  end
end
