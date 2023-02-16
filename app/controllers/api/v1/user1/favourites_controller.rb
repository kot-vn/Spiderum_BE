module Api
  module V1
    module User1
      class FavouritesController < ApplicationController
        before_action :authorize
        before_action :set_post, only: %i[create index destroy]

        def index
          favor = @post.favourites
          @pagy, @favourites = pagy(favor)
          render ({ meta: meta_data, json: favor, adapter: :json,
                    each_serializer: FavouriteSerializer }), status: :ok
        end

        def create
          @favourite = @post.favourites.build
          @favourite.user_id = @current_user.id
          if @favourite.save
            @post.update(favourite_count: @post.favourite_count + 1)
            render json: @post, serializer: ::Posts::PostLiteSerializer, status: :ok
          else
            render json: { message: 'Error' }, status: :unprocessable_entity
          end
        end

        def destroy
          if @favourite = Favourite.find_by(params[:favourite_id])
            @post.update(favourite_count: @post.favourite_count - 1)
            @favourite.destroy
            render json: { message: 'Not favourite any more' }, status: :ok
          end
        end

        private

        def set_post
          @post = Post.find_by(id: params[:post_id])
        end
      end
    end
  end
end
