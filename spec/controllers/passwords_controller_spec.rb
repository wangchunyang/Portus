require "rails_helper"

describe PasswordsController do
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
    APP_CONFIG["email"] = {
      "name"     => "Portus",
      "from"     => "portus@example.com",
      "reply_to" => "noreply@example.com"
    }

    @user = create(:admin)
    @raw  = @user.send_reset_password_instructions
  end

  it "updates the user's password on success" do
    put :update, "user" => {
      "reset_password_token"  => @raw,
      "password"              => "12341234",
      "password_confirmation" => "12341234"
    }

    expect(response.status).to eq 302
    @user.reload
    expect(@user.valid_password?("12341234")).to be true
  end

  it "does nothing if the user's password does not match confirm" do
    put :update, "user" => {
      "reset_password_token"  => @raw,
      "password"              => "12341234",
      "password_confirmation" => "12341234asdasda"
    }

    expect(response.status).to eq 302
    @user.reload
    expect(@user.valid_password?("12341234")).to be false
  end
end
