class Comment < ApplicationRecord
  paginates_per 10

  belongs_to :phone_number
  belongs_to :user
  has_many :votes, dependent: :destroy

  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }
  validates :phone_number, presence: true
  validates :user, presence: true

  after_initialize :set_default_counts, if: :new_record?

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def vote_type_by(user)
    votes.find_by(user: user)&.vote_type
  end

  private

  def set_default_counts
    self.likes_count ||= 0
    self.dislikes_count ||= 0
  end
end
