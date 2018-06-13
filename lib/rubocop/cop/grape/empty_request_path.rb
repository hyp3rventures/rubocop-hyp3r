module RuboCop
  module Cop
    module Grape
      class EmptyRequestPath < Cop
        MSG = 'Do not pass a blank path to `%<method>s`.'.freeze

        def_node_matcher :empty_request_path?, <<-PATTERN
          (send nil? {:get :post :put :head :delete :options :patch} (str #blank_string?) ...)
        PATTERN

        def on_send(node)
          return unless empty_request_path?(node)
          add_offense(node, location: node.arguments.first.loc.expression)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.remove(range_for(node))
          end
        end

        def message(send_node)
          format(MSG, method: send_node.method_name)
        end

        private

        def blank_string?(str)
          str.blank?
        end

        def range_for(node)
          range = node.arguments[0].loc.expression

          if multiple_arguments?(node)
            expand_to_next_arg(node, range)
          elsif node.parenthesized_call?
            # include the parens in the range so we don't end up with empty parens
            expand(range)
          else
            expand_to_method_call(node, range)
          end
        end

        def expand(range)
          range.adjust(begin_pos: -1, end_pos: 1)
        end

        def expand_to_next_arg(node, range)
          range.with(end_pos: node.arguments[1].loc.expression.begin_pos)
        end

        def expand_to_method_call(node, range)
          range.with(begin_pos: node.loc.selector.end_pos)
        end

        def multiple_arguments?(node)
          node.arguments.length > 1
        end
      end
    end
  end
end
