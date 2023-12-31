class LikesController < ApplicationController
  before_action :set_like, only: %i[show update destroy]

  # GET /likes
  def index
    @likes = Like.all
  end

  # GET /likes/1
  def show; end

  # POST /likes
  def create
    @like = Like.new(like_params)

    if @like.save
      render :show, status: :created, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /likes/1
  def update
    if @like.update(like_params)
      render :show, status: :ok, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy!
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:user_id, :item_id)
  end
end
