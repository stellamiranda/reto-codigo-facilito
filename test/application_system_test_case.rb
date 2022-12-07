require "test_helper"

Capybara.register_driver :root_headless_chrome do |app|
  capabilities =
    Selenium::WebDriver::Remote::Capabilities.chrome(
      "goog:chromeOptions": {
        args: [
          "headless",
          "disable-gpu",
          "no-sandbox",
          "disable-dev-shm-usage",
          "whitelisted-ips"
        ]
      },
      "goog:loggingPrefs": {browser: "ALL"}
    )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    capabilities: capabilities
  )
end # register_driver


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test
end
