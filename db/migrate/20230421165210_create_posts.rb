class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, type: :string

      t.binary :select_1 # 二進数データの保存に使用
      t.integer :maker1 # 整数値の保存に使用
      t.string :image_url1 # 画像のURLを文字列として保存に使用
      t.string :image_url2 # 画像のURLを文字列として保存に使用
      t.string :image_url22 # 上記変数名が不適切なため修正しました。画像のURLを文字列として保存に使用
      t.string :image_url23 # 上記変数名が不適切なため修正しました。画像のURLを文字列として保存に使用
      t.string :image_url3 # 上記変数名が不適切なため修正しました。画像のURLを文字列として保存に使用
      t.string :image_url33 # 上記変数名が不適切なため修正しました。画像のURLを文字列として保存に使用
      t.string :image_url34 # 上記変数名が不適切なため修正しました。画像のURLを文字列として保存に使用
      t.string :content # 投稿内容を文字列として保存に使用
      t.integer :likes_count ,default: 0
      t.string :category
      
      t.timestamps
    end
  end
end
