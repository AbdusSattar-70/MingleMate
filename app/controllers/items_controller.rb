class ItemsController < ApplicationController
      before_action :set_item, only: %i[show update destroy]

      def index
        @items = Item.all
        render json: @items
      end

      def show
        render json: @item
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

     def item_params
      params.require(:item).permit(
        :item_name,
        :collection_id,
        :user_id,
        :tags,
        custom_fields: [:field_name, :value]
     )
    end
  end