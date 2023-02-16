module Api
  module V1
    module User1
      class PostsController < ApplicationController
        before_action :set_post, only: %i[show update destroy]
        before_action :authorize, only: %i[create update destroy]
        # before_action :admin_user, only: :destroy
        before_action :correct_user, only: %i[edit update destroy]

        def index
          feed = Post.all
          @pagy, @posts = pagy(feed)
          render({ meta: meta_data, json: @posts, adapter: :json,
                   each_serializer: ::Posts::PostLiteSerializer })
        end

        def show
          @post.update(view: @post.view + 1)
          render json: @post, serializer: Posts::PostSerializer, status: :ok
        end

        def new
          @post = Post.new
        end

        def create
          @tag = Tag.find(params[:tag_id])
          @post = @tag.posts.build(post_params)
          @post.user_id = @current_user.id
          @post.month = Time.current.month
          @post.year = Time.current.year
          # @post.images.attach(params[:images])
          if @post.save
            render json: @post, serializer: ::Posts::PostSerializer, status: :ok
          else
            render json: @post.errors.full_messages, status: :unprocessable_entity
          end
        end

        def edit; end

        def update
          if @post.update(post_params)
            render json: @post, serializer: ::Posts::PostSerializer, status: :ok
          else
            render json: { error: 'Update false' }, status: :unprocessable_entity
          end
        end

        def destroy
          if @post.destroy
            render json: { message: 'Post deleted' }, status: :ok
          else
            render json: { error: 'Delete false' }, status: :unprocessable_entity
          end
        end

        def search
          @q = Post.ransack(params[:q])
          @search = @q.result
          @pagy, @search = pagy(@search)
          render({ meta: meta_data, json: @search, adapter: :json,
                   each_serializer: ::Posts::PostLiteSerializer })
        end

        def top
          @top = Post.where('posts.month' => Time.current.month)
                     .order(favourite_count: :desc)
                     .limit(10)
          render json: @top, each_serializer: ::Posts::PostLiteSerializer, status: :ok
        end

        private

        def post_params
          params.permit(:title, :content, :tag, images: [])
        end

        def set_post
          @post = Post.find(params[:id])
        end

        # in case of somebody try to delete another's post
        def correct_user
          @post = @current_user.posts.find_by(params[:id])
          if @post.nil?
            render json: { message: @post.errors.full_messages,
                           message: 'You have no right' }, status: :unauthorized
          end
        end
      end
    end
  end
end
