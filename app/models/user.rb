class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy

  # comment
  has_many :book_comments, dependent: :destroy
  # favorite
  has_many :favorites, dependent: :destroy

  #Follow associate
  has_many :active_relationships, class_name: "Relationship",
            foreign_key:"follower_id",
            dependent: :destroy
  has_many :following, through: :active_relationships,source: :followed

  has_many :passive_relationships, class_name: "Relationship",
            foreign_key:"followed_id",
            dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  #follow
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  #Unfollow
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #if current_user follow -> true
  def following?(other_user)
    following.include?(other_user)
  end

  # search
  def User.search(search, user_or_book, how_search)
    if user_or_book == "1"
      if how_search == "1"
        User.where(['name LIKE ?', "%#{search}%"])
      elsif how_search == "2"
        User.where(['name LIKE ?', "%#{search}%"])
      elsif how_search == "3"
        User.where(['name LIKE ?', "%#{search}%"])
      elsif how_search == "4"
        User.where(['name LIKE ?', "%#{search}%"])
      else
        User.all
      end
    end
  end

  # jp_prefectureをuser.rbに読み込む
  include JpPrefecture
  jp_prefecture :prefecture_code

  # postal_codeからprefecture_nameに変換するメソッド
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  # Map
  # 登録されたaddressから緯度経度のカラムにも値を自動算出
  geocoded_by :address
  # 住所変更時に緯度経度も変更
  after_validation :geocode

  attachment :profile_image
  validates :name, presence: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length: {maximum: 50}

  validates :postal_code, presence: true
  validates :prefecture_code, presence: true
  validates :address_city, presence: true
  validates :address_street, presence: true
end
