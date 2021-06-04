ENV["RUBY_ENV"] = "test"

require File.join(File.join(__dir__, "..", "config", "initializers", "zeitwerk"))
require "pry-byebug"

RSpec.configure do |config|
  config.default_formatter = "doc" if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed
end
