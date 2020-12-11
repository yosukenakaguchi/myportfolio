require 'rails_helper'

RSpec.describe "Users", type: :request do
    it "responds successfully" do
        get signup_path
        expect(response).to be_successful
        expect(response.status).to eq 200
    end
end