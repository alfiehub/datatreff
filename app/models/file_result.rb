class FileResult < ActiveRecord::Base
  belongs_to :file_competition

  has_attached_file :contribution
  validates_attachment_content_type :contribution, content_type: ['application/zip']
  validates :contribution, attachment_presence: true

  validates_with AttachmentPresenceValidator, attributes: :contribution
  validates_with AttachmentSizeValidator, attributes: :contribution, less_than: 50.megabytes

  validates :name, :comment, :contribution, presence: true
end
