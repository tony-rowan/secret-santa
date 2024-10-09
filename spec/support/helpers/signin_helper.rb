module SigninHelper
  def sign_in(user, password: "password")
    visit(root_path)
    click_on("Sign In")
    fill_in(:login, with: user.login)
    fill_in(:password, with: "password")
    click_on("Sign In")
  end
end

RSpec.configure do |config|
  config.include(SigninHelper, type: :feature)
end
