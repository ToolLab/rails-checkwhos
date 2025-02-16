class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_phone_number, only: [:create]
  before_action :set_comment, only: [:destroy, :like, :dislike]

  def create
    @comment = @phone_number.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to search_path(number: @phone_number.number), notice: "댓글이 등록되었습니다."
    else
      redirect_to search_path(number: @phone_number.number), alert: "댓글 등록에 실패했습니다. #{@comment.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to search_path(number: @comment.phone_number.number), notice: "댓글이 삭제되었습니다."
    else
      redirect_to search_path(number: @comment.phone_number.number), alert: "댓글을 삭제할 권한이 없습니다."
    end
  end

  def like
    handle_vote("like")
  end

  def dislike
    handle_vote("dislike")
  end

  private

  def handle_vote(vote_type)
    if @comment.user == current_user
      redirect_to search_path(number: @comment.phone_number.number), 
        alert: "자신의 댓글에는 투표할 수 없습니다."
      return
    end

    existing_vote = @comment.votes.find_by(user: current_user)

    if existing_vote
      if existing_vote.vote_type == vote_type
        existing_vote.destroy
        message = "투표를 취소했습니다."
      else
        existing_vote.update(vote_type: vote_type)
        message = vote_type == "like" ? "좋아요로 변경했습니다." : "싫어요로 변경했습니다."
      end
    else
      @comment.votes.create!(user: current_user, vote_type: vote_type)
      message = vote_type == "like" ? "좋아요를 눌렀습니다." : "싫어요를 눌렀습니다."
    end

    redirect_to search_path(number: @comment.phone_number.number), notice: message
  end

  private

  def set_phone_number
    number = params[:phone_number_number].to_s.gsub(/[^0-9]/, "")
    country_code = "82" # 한국 국가 코드
    country = "kr"

    @phone_number = PhoneNumber.find_or_create_by!(
      country_code: country_code,
      country: country,
      number: number
    )
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
