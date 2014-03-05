shared_examples "require_sign_in" do
  it "redirects to the sign_in_path" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "tokenable" do
  it "generates a random token when record is created" do
    expect(object.token).not_to eq(nil)
  end
end
