class PhoneNumber < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :country_code, presence: true
  validates :country, presence: true
  validates :number, presence: true, uniqueness: { scope: [:country_code, :country] }
  
  def formatted_number
    case country
    when "kr"
      if number.length == 11
        "#{number[0..2]}-#{number[3..6]}-#{number[7..10]}"
      elsif number.length == 10
        "#{number[0..1]}-#{number[2..5]}-#{number[6..9]}"
      else
        number
      end
    else
      number
    end
  end
end
