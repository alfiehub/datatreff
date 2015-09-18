class RemoveImageFromResult < ActiveRecord::Migration
  def change
    remove_attachment :results, :image
  end
end
