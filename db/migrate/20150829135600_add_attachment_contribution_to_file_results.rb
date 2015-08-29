class AddAttachmentContributionToFileResults < ActiveRecord::Migration
  def self.up
    change_table :file_results do |t|
      t.attachment :contribution
    end
  end

  def self.down
    remove_attachment :file_results, :contribution
  end
end
