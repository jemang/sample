class RandomUser < Flexirest::Base
  base_url "https://randomuser.me/api"

  get :all, "/?results=20"
end
