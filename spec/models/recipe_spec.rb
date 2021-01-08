require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }

  it "作成ユーザー、タイトル、作品名、監督・著者、紹介文、材料・調味料、作り方がある場合、有効である" do
    expect(recipe).to be_valid
  end

  it "" do
  end

  it "" do
  end

  it "" do
  end

  it "" do
  end

  it "" do
  end

  it "" do
  end


end
