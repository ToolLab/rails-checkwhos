class PageView < ApplicationRecord
  belongs_to :phone_number

  validates :ip, presence: true
  validates :viewed_at, presence: true

  before_validation :set_viewed_at

  scope :today, -> { where(viewed_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :last_week, -> { where(viewed_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }

  private

  def set_viewed_at
    self.viewed_at ||= Time.current
  end
end
