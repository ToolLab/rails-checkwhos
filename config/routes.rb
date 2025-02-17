Rails.application.routes.draw do
  # Sitemap
  get "sitemap.xml", to: "sitemaps#show", defaults: { format: "xml" }

  # 루트 경로를 /kr로 리다이렉트
  root to: redirect("/kr")

  # 한국어 사이트 라우팅 (/kr)
  scope "/:locale", locale: /kr/ do
    # devise 라우트를 scope 안으로 이동
    devise_for :users, path: ""

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

  # scope 밖의 모든 경로를 /kr로 리다이렉트
  get "/*path", to: redirect("/kr/%{path}"), constraints: lambda { |req|
    !req.path.start_with?("/kr/") && !req.path.start_with?("/up")
  }

  # 상태 체크 엔드포인트
  get "up" => "rails/health#show", as: :rails_health_check
end
