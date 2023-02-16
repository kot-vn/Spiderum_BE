module Api
  module V1
    module User1
      class UsersController < ApplicationController
        before_action :authorize, only: %i[index edit update destroy feed my_favourites search search_to_mess my_posts]
        before_action :set_user, only: %i[show edit update destroy search search_to_mess]
        before_action :correct_user, only: %i[edit update]
        before_action :admin_user, only: :destroy
        # before_action :validate_email_update

        def index
          all_user = User.all
          @pagy, @users = pagy(all_user)
          render ({ meta: meta_data, json: @users, adapter: :json, each_serializer: ::Users::UserLiteSerializer }),
                 status: :ok
        end

        def show
          render json: @user, serializer: ::Users::UserSerializer, status: :ok
        end

        def new
          @user = User.new
        end

        def create
          @user = User.new(user_params)
          @user.image.attach(params[:image])
          if @user.password == @user.password_confirmation
            @user.save
            SendMailJob.perform_later @user
            render json: { message: 'Please check your email to active account' }, status: :ok
          else
            render json: { message: 'Password incorrect!' }, status: :unprocessable_entity
          end
        end

        def edit; end

        def update
          if @user.update(user_params)
            render json: { user: @user }, status: :ok
          else
            render json: @user.errors.full_messages, status: :unprocessable_entity
          end
        end

        # def change_email
        #   if @current_user.update_new_email!(@new_email)
        #     @current_user.send_update_email
        #     render json: { status: 'Email Confirmation has been sent to your new Email.' }, status: :ok
        #   else
        #     render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        #   end
        # end

        # update | change email
        # def email_update
        #   token = params[:token].to_s
        #   @user = User.find_by(confirmation_token: token)
        #   if !@user || !@user.confirmation_token_valid?
        #     render json: {error: 'The email link seems to be invalid / expired. Try requesting for a new one.'}, status: 404
        #   else
        #     @user.update_new_email
        #     render json: {status: 'Email updated successfully'}, status: :ok
        #   end
        # end

        # Confirm email, active account
        def confirm
          token = params[:token].to_s
          @user = User.find_by(confirmation_token: token)
          if @user.present? && @user.confirmation_sent_at + 30.days > Time.now.utc
            @user.confirmation_token = nil
            @user.confirmed_at = Time.now.utc
            @user.save
            render json: { status: 'User confirmed successfully' }, status: :ok
          else
            render json: { status: 'Invalid token' }, status: :not_found
          end
        end

        # Ban user
        def destroy
          @user.update(banned: true, time_ban: Time.now.utc)
          render json: { message: 'User has been banned' }, status: :ok
        end

        def following
          @title = 'Following'
          @user = User.find(params[:id])
          @users = @user.following
          @pagy, @users = pagy(@users)
          render ({ meta: meta_data, json: @users, adapter: :json,
                    each_serializer: ::Users::UserLiteSerializer }), status: :ok
        end

        def followers
          @title = 'Followers'
          @user = User.find(params[:id])
          @users = @user.followers
          @pagy, @users = pagy(@users)
          render ({ meta: meta_data, json: @users, adapter: :json,
                    each_serializer: ::Users::UserLiteSerializer }), status: :ok
        end

        def my_favourites
          @title = 'my_favourites'
          @favourite = @current_user.favourites
          @pagy, @favourite = pagy(@favourite)
          render ({ meta: meta_data, json: @favourite, adapter: :json,
                    each_serializer: ::Users::MyFavouritesSerializer }), status: :ok
        end

        def my_posts
          my_posts = Post.where('user_id =  ?', params[:id])
          @pagy, @my_posts = pagy(my_posts)
          render ({ meta: meta_data, json: @my_posts, adapter: :json,
                    each_serializer: ::Posts::PostLiteSerializer }), status: :ok
        end

        def feed
          following_ids = Relationship.select(:followed_id)
                                      .where('follower_id = ?', params[:id])
          # @post = Post.where('user_id = ?', params[:id])
          @post_following = Post.where(user_id: following_ids)
                                .order(created_at: :desc)
          @pagy, @feed = pagy(@post_following)
          render({ meta: meta_data, json: @feed, adapter: :json,
                   each_serializer: ::Posts::PostLiteSerializer })
        end

        def search
          @users = User.all
          @q = @users.ransack(params[:q])
          @search = @q.result
          @pagy, @search = pagy(@search)
          render ({ meta: meta_data, json: @search, adapter: :json,
                    each_serializer: ::Users::UserLiteSerializer }), status: :ok
        end

        def search_to_mess
          @users = @user.following
          @q = @users.ransack(params[:q])
          @search = @q.result
          if @search
            @pagy, @search = pagy(@search)
            render ({ meta: meta_data, json: @search, adapter: :json,
                      serializer: ::Users::UserLiteSerializer }), status: :ok
          else
            render json: 'You have no relationship with this one', status: :ok
          end
        end

        private

        # set user with params id
        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.permit(:name, :email, :password, :password_confirmation, :image)
        end

        # Confirms the correct user.
        def correct_user
          @user = User.find(params[:id])
          render josn: { message: 'You have no right to do this!' } unless @user == @current_user
        end

        def validate_email_update
          @new_email = params[:email].to_s.downcase
          if @new_email.blank?
            return render json: { status: 'Email cannot be blank' },
                          status: :bad_request
          end
          if @new_email == @current_user.email
            return render json: { status: 'Current Email and New email cannot be the same' },
                          status: :bad_request
          end

          if User.email_used?(@new_email)
            render json: { error: 'Email is already in use.' },
                   status: :unprocessable_entity
          end
        end
      end
    end
  end
end
