class PhoneNumber < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :country_code, presence: true
  validates :country, presence: true
  validates :number, presence: true, uniqueness: { scope: [:country_code, :country] }
  
  # SEO를 위한 형식 (하이픈 없음)
  def seo_number
    number
  end

  # 화면 표시용 형식 (하이픈 포함)
  def formatted_number
    return number if country != "kr"
    
    case number.length
    when 8 # 1544-1234
      "#{number[0..3]}-#{number[4..7]}"
    when 9 # 02-123-1234
      if number.start_with?("02")
        "#{number[0..1]}-#{number[2..4]}-#{number[5..8]}"
      else
        "#{number[0..2]}-#{number[3..5]}-#{number[6..8]}"
      end
    when 10 # 02-1234-1234 또는 032-123-1234
      if number.start_with?("02")
        "#{number[0..1]}-#{number[2..5]}-#{number[6..9]}"
      else
        "#{number[0..2]}-#{number[3..5]}-#{number[6..9]}"
      end
    when 11 # 010-1234-1234
      "#{number[0..2]}-#{number[3..6]}-#{number[7..10]}"
    else
      number
    end
  end
end
