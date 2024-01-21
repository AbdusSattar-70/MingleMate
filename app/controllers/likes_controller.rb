class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  # GET /item_likes_count/:item_id
  def item_likes_count
    item_id = params[:item_id]
    @likes = Like.where(item_id:)
    render json: serialize_likes(@likes)
  end

  # POST /likes
  def create
    existing_like = Like.find_by(user_id: like_params[:user_id], item_id: like_params[:item_id])

    if existing_like
      render json: { message: 'You have already liked this item' }, status: :unprocessable_entity
    else
      @like = Like.new(like_params)

      if @like.save
        render json: @like, status: :created, location: @like
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :item_id)
  end

  def serialize_likes(likes)
    likes.map { |like| serialize_like(like) }
  end

  def serialize_like(like)
    {
      id: like.id,
      user_id: like.user_id,
      user_name: like.user&.user_name,
      user_photo: like.user&.avatar
    }
  end
end
