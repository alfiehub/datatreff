class Screenshot < ActiveRecord::Base
  belongs_to :result

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
  validates :image, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :image
  validates_with AttachmentSizeValidator, :attributes => :image, :less_than => 20.megabytes
end
