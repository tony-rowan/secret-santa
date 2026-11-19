# frozen_string_literal: true

module RuboCop
  module Cop
    module SecretSanta
      # Use Rails 8's `params.expect` instead of `params.require(...).permit(...)`. It checks the
      # shape of the params too, so a malformed request gets a 400 rather than a 500.
      #
      # @example
      #   # bad
      #   params.require(:idea).permit(:idea)
      #
      #   # good
      #   params.expect(idea: [:idea])
      class ParamsExpect < Base
        extend AutoCorrector

        MSG = "Use `params.expect(%<key>s: [...])` instead of `params.require(...).permit(...)`."
        RESTRICT_ON_SEND = %i[permit].freeze

        # @!method require_permit(node)
        def_node_matcher :require_permit, <<~PATTERN
          (send (send (send nil? :params) :require $_) :permit $...)
        PATTERN

        def on_send(node)
          require_permit(node) do |key, permitted|
            add_offense(node, message: format(MSG, key: key_source(key))) do |corrector|
              corrector.replace(node, "params.expect(#{expect_argument(key, permitted)})")
            end
          end
        end

        private

        def expect_argument(key, permitted)
          attributes = "[#{permitted.map(&:source).join(", ")}]"

          if key.sym_type? && key.value.match?(/\A[a-z_][a-zA-Z0-9_]*\z/)
            "#{key.value}: #{attributes}"
          else
            "#{key.source} => #{attributes}"
          end
        end

        def key_source(key)
          key.sym_type? ? key.value : key.source
        end
      end
    end
  end
end
