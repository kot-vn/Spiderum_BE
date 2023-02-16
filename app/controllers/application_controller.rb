class ApplicationController < ActionController::API
  include Pagy::Backend
  include ActiveStorage::SetCurrent
  # def paginate(resource)
  #   resource = resource.page(params[:page] || 1)
  #   resource = resource.per_page(params[:per_page]) if params[:per_page]
  #   resource
  # end
  # before_action :current_option_url, only: :upload_image

  # def encode_token(payload)
  #   JWT.encode(payload, 'secret')
  # end
  BEARER_AUTHORIZATION = 'Bearer'

  def decode_token
    auth_header = request.headers['Authorization']
    if auth_header
      return nil unless token

      begin
        JWT.decode(token, Rails.application.secrets.secret_key_base).first
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorized_user
    decoded_token = decode_token
    if decoded_token
      user_id = decoded_token['id']
      @current_user = User.find_by(id: user_id)
    end
  end

  def authorize
    render json: { message: 'You have to log in.' }, status: :unauthorized unless
    authorized_user
  end

  def upload_image
    blob = ActiveStorage::Blob.create_and_upload!(io: File.open(params[:file]),
                                                  filename: params[:file])
    render json: { image_url: blob.url }
  end

  private

  # Confirms an admin user.
  def admin_user
    @current_user.admin?
  end

  def log_out
    current_user = nil
  end

  def meta_data
    {
      total: @pagy.count,
      page: @pagy.page,
      from: @pagy.from,
      to: @pagy.to,
      pages: @pagy.pages
    }
  end

  def token
    authen, token = request.headers['Authorization'].to_s.split(' ')
    return unless authen == BEARER_AUTHORIZATION

    token
  end
end
