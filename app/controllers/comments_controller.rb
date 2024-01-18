class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  # GET /comments/1
  def show
    render json: serialize_comment(@comment)
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: serialize_comment(@comment), status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: { message: 'successfully updated', data: serialize_comment(@comment) }, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity

    end
  end

  # DELETE /comments/1
  def destroy
    if @comment.destroy
      render json: { message: 'successfully deleted', data: serialize_comment(@comment) }, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

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

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :item_id, :user_id)
  end
end
