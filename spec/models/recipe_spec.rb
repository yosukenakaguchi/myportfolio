require 'rails_helper'

RSpec.describe Recipe, type: :model, focus: :true do
  let!(:recipe) { build(:recipe) }
  let!(:how_to_make) { build(:how_to_make, recipe: recipe) }
  let!(:ingredient) { build(:ingredient, recipe: recipe) }

  it "作成ユーザー、タイトル、作品名、監督・著者、紹介文、材料・調味料、作り方がある場合、有効である" do
    expect(recipe).to be_valid
  end

end
