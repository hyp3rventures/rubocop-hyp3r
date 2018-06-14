require 'rubocop/hyp3r/version'

module RuboCop
  module Hyp3r
    PROJECT_ROOT   = Pathname.new(__dir__).parent.parent.expand_path.freeze
    CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze

    private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
  end
end
