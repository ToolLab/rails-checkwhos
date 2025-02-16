class HomeController < ApplicationController
  def index
    @recent_numbers = PhoneNumber.order(created_at: :desc).limit(100)
    @recent_comments = Comment.includes(:user, :phone_number).order(created_at: :desc).limit(100)
  end

  def search
    number = params[:number].gsub(/[^0-9]/, "")
    country_code = "82" # 한국 국가 코드
    country = "kr"

    @phone_number = PhoneNumber.find_by(
      country_code: country_code,
      country: country,
      number: number
    )

    if @phone_number
      @comments = @phone_number.comments.includes(:user).order(created_at: :desc).page(params[:page])
    else
      @phone_number = PhoneNumber.new(
        country_code: country_code,
        country: country,
        number: number
      )
      @comments = Comment.none.page(params[:page])
    end

    @comment = Comment.new(phone_number: @phone_number)
  end
end
