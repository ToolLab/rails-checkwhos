class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :vote_type, presence: true, inclusion: { in: ["like", "dislike"] }
  validates :user_id, uniqueness: { scope: :comment_id, message: "하나의 댓글에 한 번만 투표할 수 있습니다." }

  after_create :increment_counter
  before_destroy :decrement_counter

  private

  def increment_counter
    if vote_type == "like"
      comment.increment!(:likes_count)
    else
      comment.increment!(:dislikes_count)
    end
  end

  def decrement_counter
    if vote_type == "like"
      comment.decrement!(:likes_count)
    else
      comment.decrement!(:dislikes_count)
    end
  end
end
