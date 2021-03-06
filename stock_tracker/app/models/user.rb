class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :search_friend, ->(q) {
          where(
            "email LIKE ? OR first_name LIKE ? OR last_name LIKE ?",
            "%#{q}%", "%#{q}%", "%#{q}%"
          )
        }

  def already_tracked?(ticker_symbol)
    stock = Stock.grab_stock(ticker_symbol).first
    return false unless stock

    stocks.where(id: stock).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def track_stock?(ticker_symbol)
    under_stock_limit? && !already_tracked?(ticker_symbol)
  end

  def full_name
    "#{first_name} #{last_name}" if first_name || last_name
  end
end
