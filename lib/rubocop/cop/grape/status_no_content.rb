module RuboCop
  module Cop
    module Grape
      class StatusNoContent < Cop
        MSG = 'Use `body false` instead of `%<param>s`.'.freeze

        def_node_matcher :status_no_content?, <<-PATTERN
          (send nil? :status {(sym :no_content) (int 204)})
        PATTERN

        def on_send(node)
          return unless status_no_content?(node)
          add_offense(node)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.loc.expression, 'body false')
          end
        end

        def message(send_node)
          format(MSG, param: send_node.source)
        end
      end
    end
  end
end
