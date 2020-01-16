require 'open-uri'

class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, dependent: :destroy
  has_many :morning_activity_results, dependent: :destroy
  accepts_nested_attributes_for :authentications
  has_one_attached :avatar
  has_one_attached :post_picture

  def download_and_attach_avatar(filename)
    filename = filename&.gsub(/_normal/, '')
    return unless filename

    file = open(filename)
    avatar.attach(io: file,
                  filename: "avatar.#{file.content_type_parse.first.split("/").last}",
                  content_type: file.content_type_parse.first)
  end

  def post_picture_path
    # ActiveStorage::Blob.service.path_for(post_picture.key)
    Rails.application.routes.url_helpers.rails_blob_path(post_picture)
  end
end
