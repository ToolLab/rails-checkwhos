class HomeController < ApplicationController
  after_action :record_page_view, only: [ :search ]

  def index
    @recent_numbers = PhoneNumber.order(created_at: :desc).limit(100)
    @recent_comments = Comment.includes(:user, :phone_number).order(created_at: :desc).limit(100)
  end

  def search
    if params[:number].present?
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
        @comment = Comment.new(phone_number: @phone_number)
      else
        @phone_number = PhoneNumber.new(
          country_code: country_code,
          country: country,
          number: number
        )
        @comments = Comment.none.page(params[:page])
        @comment = Comment.new(phone_number: @phone_number)
      end
    else
      @phone_number = nil
      @comments = Comment.none.page(params[:page])
      @comment = nil
    end
  end

  private

  def get_visitor_ip
    # Cloudflare의 CF-Connecting-IP 헤더 확인
    cf_ip = request.headers["CF-Connecting-IP"]
    return cf_ip if cf_ip.present?

    # X-Forwarded-For 헤더 확인
    forwarded_for = request.headers["X-Forwarded-For"]
    if forwarded_for.present?
      forwarded_for.split(",").first.strip
    else
      request.remote_ip
    end
  end

  def record_page_view
    return unless @phone_number&.persisted?

    # 세션에서 최근 본 번호들을 가져옴
    viewed_numbers = session[:viewed_numbers] || {}
    current_time = Time.current

    # 같은 번호를 5분 이내에 다시 보면 조회수를 증가시키지 않음
    last_view_time = viewed_numbers[@phone_number.id.to_s]
    return if last_view_time && Time.parse(last_view_time) > 5.minutes.ago

    # 조회 기록 생성
    @phone_number.page_views.create!(
      ip: get_visitor_ip,
      referrer: request.referrer,
      user_agent: request.user_agent,
      viewed_at: current_time
    )

    # 세션 업데이트
    viewed_numbers[@phone_number.id.to_s] = current_time.iso8601
    session[:viewed_numbers] = viewed_numbers
  end
end
