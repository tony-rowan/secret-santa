module Middleware
  module Test
    class Authentication
      AUTHENTICATE_PATH_PREFIX = "/__authenticate__/".freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)

        if authenticate_path?(request.path)
          authenticate_user(request)

          [200, {}, []]
        else
          @app.call(env)
        end
      end

      private

      def authenticate_path?(path)
        path.start_with?(AUTHENTICATE_PATH_PREFIX)
      end

      def authenticate_user(request)
        request.cookie_jar.encrypted[:user_id] = user_id_from_request(request.path)
      end

      def user_id_from_request(path)
        path.split("/").last
      end
    end
  end
end
