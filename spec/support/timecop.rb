# frozen_string_literal: true

RSpec.configure do |config|
  config.after(timecop: true) do
    Timecop.return
  end
end
