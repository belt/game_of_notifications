require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.push_dir("./config/initializers")
loader.push_dir("./lib")
loader.setup

# load everything now in production rails-env
loader.eager_load unless %w[development test].include?(ENV["RUBY_ENV"].to_s.downcase)
