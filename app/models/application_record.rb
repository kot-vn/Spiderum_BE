class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # include Rails.application.routes.url_helpers

  def set_images_url
    if images.attached?
      self.images_url = []
      images.each do |image|
        self.images_url << Rails.application.routes.url_helpers.url_for(image)
      end
    end
  end

  def set_image_url
    self.image_url = Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
