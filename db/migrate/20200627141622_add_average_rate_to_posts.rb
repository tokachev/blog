class AddAverageRateToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :average_rate, :float
  end
end
