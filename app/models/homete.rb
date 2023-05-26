class Homete < ApplicationRecord
    mount_uploaders :images, ImageUploader
    #serialize :images, JSON
    validates :content, presence: true

end
