class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # relationshipモデル
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  # enumで論理削除機能

  enum valid_status: { active: 0, is_deleted: 1 }

  def withdraw!
    if active?
      is_deleted!
    else
      active!
    end
  end

  def active_for_authentication?
     super && self.valid_status == "active"
  end



  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end


  def User.search(search,user_or_book,how_search)
    if user_or_book == "1"
    if how_search == "1"
      User.where(['name LIKE ?',"%#{search}%"])
    elsif how_search == "2"
      User.where(['name LIKE ?',"%#{search}"])
    elsif how_search == "3"
      User.where(['name LIKE ?',"#{search}%"])
    elsif how_search == "4"
      User.where(['name LIKE ?',"#{search}"])
    else
      User.all
    end
    end
  end

	attachment :profile_image

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}
   attachment :profile_image, destroy: false
end
