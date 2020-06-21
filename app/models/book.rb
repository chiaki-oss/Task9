class Book < ApplicationRecord
	belongs_to :user
	# comment/favorites
	has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy
	# favorite
	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	# search
	def Book.search(search, user_or_book, how_search)
		if how_search == "1"
			Book.where(['title LIKE ?', "%#{search}%"])
		elsif how_search == "2"
			Book.where(['title LIKE ?', "%#{search}%"])
		elsif how_search == "3"
			Book.where(['title LIKE ?', "%#{search}%"])
		elsif how_search == "4"
			Book.where(['title LIKE ?', "%#{search}%"])
		else
			Book.all
		end
	end

	validates :title, presence: true
	validates :body, presence:true,
	           length: { maximum: 200}
end
