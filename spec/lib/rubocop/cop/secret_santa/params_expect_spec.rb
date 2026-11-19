require "spec_helper"
require "rubocop"
require "rubocop/rspec/support"
require_relative "../../../../../lib/rubocop/cop/secret_santa/params_expect"

RSpec.describe RuboCop::Cop::SecretSanta::ParamsExpect, :config do
  include RuboCop::RSpec::ExpectOffense

  it "corrects require and permit to expect" do
    expect_offense(<<~RUBY)
      params.require(:idea).permit(:idea)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `params.expect(idea: [...])` instead of `params.require(...).permit(...)`.
    RUBY

    expect_correction(<<~RUBY)
      params.expect(idea: [:idea])
    RUBY
  end

  it "keeps every permitted attribute, nested ones included, and any chained calls" do
    expect_offense(<<~RUBY)
      params.require(:user).permit(:name, :email, tags: []).merge(owner: user)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `params.expect(user: [...])` instead of `params.require(...).permit(...)`.
    RUBY

    expect_correction(<<~RUBY)
      params.expect(user: [:name, :email, tags: []]).merge(owner: user)
    RUBY
  end

  context "when the key isn't a plain symbol" do
    it "uses a hash rocket" do
      expect_offense(<<~RUBY)
        params.require(key).permit(:name)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `params.expect(key: [...])` instead of `params.require(...).permit(...)`.
      RUBY

      expect_correction(<<~RUBY)
        params.expect(key => [:name])
      RUBY
    end
  end

  it "accepts params.expect" do
    expect_no_offenses(<<~RUBY)
      params.expect(idea: [:idea])
    RUBY
  end

  it "accepts permit on something other than params.require" do
    expect_no_offenses(<<~RUBY)
      params.permit(:name)
      other.require(:idea).permit(:idea)
    RUBY
  end
end
