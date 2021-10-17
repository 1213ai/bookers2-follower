class Book < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def user
    return User.find_by(id: self.user_id)
  end
  
  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'old'
      return all.order(created_at: :ASC)
    when 'likes'
      return find(Favorite.group(:book_id).order(Arel.sql('count(book_id) desc')).pluck(:book_id))
    when 'dislikes'
      return find(Favorite.group(:book_id).order(Arel.sql('count(book_id) asc')).pluck(:book_id))
    end
  end

end

