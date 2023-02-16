module Api
  module V1
    module User1
      class RelationshipsController < ApplicationController
        before_action :authorize

        def create
          @user = User.find_by(id: params[:user_id])
          unless @user && @user.followers.find_by(id: params[:id])
            @current_user.follow(@user)
            render json: { message: 'Follow' }, status: :ok
            @current_user.increment! :following_count
            @user.increment! :follower_count
          end
        end

        def destroy
          @user = User.find_by(id: params[:user_id])
          if @user.followers.find_by(params[:id])
            @current_user.unfollow(@user)
            render json: { message: 'Unfollow' }, status: :ok
            @current_user.decrement! :following_count
            @user.decrement! :follower_count
          end
        end
      end
    end
  end
end
