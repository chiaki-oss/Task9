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

  # chat
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  #dmしてるユーザー一覧用
  has_many :rooms, through: :entries

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
  # source: 関連モデルを指定
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # 既にフォローしているかの確認
  # .include?(user)メソッド： 引数userが含まれているか確認
  def following?(user)
    following_user.include?(user)
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
