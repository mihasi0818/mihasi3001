class Comment < ApplicationRecord
    #コメント機能
   belongs_to :post
   belongs_to :user
   validates :content, length: { minimum: 1 }
   
  end
  
  
  