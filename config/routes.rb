Rails.application.routes.draw do
  # Sitemap
  get "sitemap.xml", to: "sitemaps#show", defaults: { format: "xml" }

  devise_for :users

  # 한국어 사이트 라우팅 (/kr)
  scope "(:locale)", locale: /kr/ do
    root "home#index"
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

  # 상태 체크 엔드포인트
  get "up" => "rails/health#show", as: :rails_health_check
end
