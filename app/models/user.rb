class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   has_many :articles, dependent: :destroy
   has_many :books, dependent: :destroy
   has_many :favorites, dependent: :destroy
   has_many :book_comments, dependent: :destroy
   
   has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
   has_many :followers, through: :reverse_of_relationships, source: :follower
   has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
   has_many :followings, through: :relationships, source: :followed

   validates :name, length: { minimum:2, maximum: 20 }
   validates :name, uniqueness: true


   validates :introduction, length: { maximum: 50 }
   attachment :profile_image

  def books
   return Book.where(user_id: self.id)
  end
  
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  def following?(user)
    followings.include?(user)
  end
  
  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'high'
      return all.order(rate :DESC)
    end
  end
  
  
  
  
end
