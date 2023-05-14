class AddImageUrl40ToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :image_url40, :string
    add_column :posts, :image_url41, :string
    add_column :posts, :image_url42, :string
    add_column :posts, :image_url43, :string
    add_column :posts, :image_url44, :string
    add_column :posts, :image_url50, :string
    add_column :posts, :image_url51, :string
    add_column :posts, :image_url60, :string
    add_column :posts, :image_url61, :string
  end
end
