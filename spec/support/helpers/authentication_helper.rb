module AuthenticationHelpers
  module FeatureHelper
    include AuthenticationHelpers

    def authenticate(user)
      visit(authenticate_path(user))
    end
  end

  module RequestHelper
    include AuthenticationHelpers

    def authenticate(user)
      get(authenticate_path(user))
    end
  end

  def authenticate_path(user)
    "#{Middleware::Test::Authentication::AUTHENTICATE_PATH_PREFIX}#{user.id}"
  end
end

RSpec.configure do |config|
  config.include(AuthenticationHelpers::FeatureHelper, type: :feature)
  config.include(AuthenticationHelpers::RequestHelper, type: :request)
end
