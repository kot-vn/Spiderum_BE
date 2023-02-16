module Api
  module V1
    module User1
      class CommentsController < ApplicationController
        before_action :find_commentable
        before_action :authorize
        before_action :correct_user, only: %i[edit update destroy]
        # before_action :admin_user, only: :destroy

        def new
          @comment = Comment.new
        end

        def index
          @comments = @commentable.comments
          @pagy, all_comments = pagy(@comments)
          render ({meta: meta_data, json: all_comments, adapter: :json, each_serializer: CommentSerializer })
        end

        def create
          @comment = @commentable.comments.build(comment_params)
          @comment.user_id = @current_user.id
          if @comment.save
            render json: @comment, serializer: CommentSerializer, status: :ok
          else
            render json: @comment.errors.full_messages, status: :unprocessable_entity
          end
        end

        def destroy
          @comment = Comment.find(params[:id])
          if @comment.destroy
            render json: { message: 'Comment deleted' }, status: :ok
          else
            render json: @comment.errors.full_messages, status: :unprocessable_entity
          end
        end

        def edit; end

        def update
          @comment = Comment.find(params[:id])
          if @comment.update(comment_params)
            render json: @comment, serializer: CommentSerializer, status: :ok
          else
            render json: @comment.errors.full_messages, status: :unprocessable_entity
          end
        end

        private

        def comment_params
          params.require(:comment).permit(:body)
        end

        def find_commentable
          if params[:comment_id]
            @commentable = Comment.find_by_id(params[:comment_id])
          elsif params[:post_id]
            @commentable = Post.find_by_id(params[:post_id])
          end
        end

        # in case of somebody try to delete another's comment
        def correct_user
          @comment = @current_user.comments.find_by(id: params[:id])
          if @comment.nil?
            render json: { message: @comment.errors.full_messages, message: 'You have no right' }, status: :unauthorized
          end
        end
      end
    end
  end
end
