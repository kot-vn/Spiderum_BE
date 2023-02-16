module Api
  module V1
    module User1
      class VotesController < ApplicationController
        before_action :authorize
        before_action :find_votetable

        def upvote
          @vote = @votetable.votes.build
          @vote.user_id = @current_user.id
          @vote.vote_action = "Upvote"
          if @vote.save
            @votetable.update(vote_sum: @votetable.vote_sum + 1)
            render json: @vote, serializer: nil, status: :ok
          else
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end

        def downvote
          @vote = @votetable.votes.build
          @vote.user_id = @current_user.id
          @vote.vote_action = "Downvote"
          if @vote.save
            @votetable.update(vote_sum: @votetable.vote_sum - 1)
            render json: { vote: @vote }, status: :ok
          else
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end

        def destroy
          @vote = Vote.find_by(params[@current_user.id])
          if @vote.vote_action == "Upvote" && @vote.destroy
            @vote.votetable.update(vote_sum: @votetable.vote_sum - 1)
            render json: { message: 'Unvote' }, status: :ok
          elsif @vote.vote_action == "Downvote" && @vote.destroy
            @vote.votetable.update(vote_sum: @votetable.vote_sum + 1)
            render json: { message: 'Unvote' }, status: :ok
          else
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end

        private

        def find_votetable
          if params[:comment_id]
            @votetable = Comment.find_by_id(params[:comment_id])
          elsif params[:post_id]
            @votetable = Post.find_by_id(params[:post_id])
          end
        end
      end
    end
  end
end
