class FileResult < ActiveRecord::Base
  MIME_TYPES = ["application/zip", "application/x-zip", "application/rar-compressed", "application/rar", "application/x-rar-compressed", "application/octet-stream", "multipart/x-zip", "application/x-zip-compressed", "application/x-compressed"]

  belongs_to :file_competition
  belongs_to :user

  has_attached_file :contribution
  validates_attachment_content_type :contribution, content_type: MIME_TYPES
  validates :contribution, attachment_presence: true

  validates_with AttachmentPresenceValidator, attributes: :contribution
  validates_with AttachmentSizeValidator, attributes: :contribution, less_than: 50.megabytes

  validates :name, :comment, :contribution, presence: true

  before_post_process :skip_for_zip
  def skip_for_zip
    ! MIME_TYPES.include?(contribution_content_type)
  end
end
