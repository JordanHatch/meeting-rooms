RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    # Reset authentication environment vars
    ENV['USERNAME'] = nil
    ENV['PASSWORD'] = nil
  end
end
