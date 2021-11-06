module LoginHelper
  def login(user, password: "password")
    visit(root_path)
    click_on("Log In")
    fill_in(:login, with: user.login)
    fill_in(:password, with: "password")
    click_on("Log In")
  end
end

RSpec.configure do |config|
  config.include(LoginHelper)
end
