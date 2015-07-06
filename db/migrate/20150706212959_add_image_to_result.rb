class AddImageToResult < ActiveRecord::Migration
  def change
    add_attachment :results, :image
  end
end
