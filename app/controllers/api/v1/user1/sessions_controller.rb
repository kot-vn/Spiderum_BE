module Api
  module V1
    module User1
      class SessionsController < ApplicationController
        before_action :authorize, only: :destroy

        def create
          @user = User.find_by(email: params[:email])
          if @user && @user.valid_password?(params[:password])
            if is_banned?
            elsif !@user.confirmation_token?
              token = @user.create_token
              render json: { user: @user, token: }, status: :ok
            else
              render json: { message1: 'Account not activated.',
                             message2: 'Check your email for the activation link.' }
            end
          else
            render json: { message: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @current_user = nil
          render json: { message: 'Logged out' }, status: :ok
        end

        private

        def is_banned?
          if @user.banned? && @user.time_ban >= Time.now.utc - 1.minutes
            render json: { message: 'You fukin bastard has been banned oloo' }, status: :ok
          elsif @user.update(time_ban: @user.time_ban = nil, banned: @user.banned = 0)
          end
        end
      end
    end
  end
end
