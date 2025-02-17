Rails.application.routes.draw do
  # Sitemap
  get "sitemap.xml", to: "sitemaps#show", defaults: { format: "xml" }

  # Devise 라우팅
  devise_for :users

  # 루트 경로를 /kr로 리다이렉트
  root to: redirect("/kr")

  # 한국어 사이트 라우팅 (/kr)
  scope "/:locale", locale: /kr/ do
    get "/", to: "home#index", as: :locale_root
    get "search/:number", to: "home#search", as: :search

    resources :phone_numbers, param: :number, only: [] do
      resources :comments, only: [ :create ]
    end

    resources :comments, only: [ :destroy ], param: :id do
      member do
        post "like"
        post "dislike"
      end
    end
  end

  # 검색 관련 경로만 /kr로 리다이렉트
  get "/search/*path", to: redirect("/kr/search/%{path}")

  # 상태 체크 엔드포인트
  get "up" => "rails/health#show", as: :rails_health_check
end
