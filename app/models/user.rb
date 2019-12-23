require 'open-uri'

class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  has_one_attached :avatar

  def download_and_attach_avatar(filename)
    binding.pry
    filename = filename&.gsub(/_normal/, '')
    return unless filename

    file = open(filename)
    binding.pry
    avatar.attach(io: file,
                  filename: "avatar.#{file.content_type_parse.first.split("/").last}",
                  content_type: file.content_type_parse.first)
    binding.pry
  end
end
