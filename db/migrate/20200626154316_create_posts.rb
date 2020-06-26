class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.belongs_to :user
      t.string :title
      t.text :content
      t.string :ip

      t.timestamps
    end
  end
end
