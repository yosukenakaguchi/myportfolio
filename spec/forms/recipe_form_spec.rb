require 'rails_helper'

RSpec.describe RecipeForm do
  describe '#execute' do
    subject { form.save }
    let(:user) {create(:user)}
    let(:params) do
      {
        "title"=>"hoge",
        "content"=>"hoge",
        "work"=>"hoge",
        "author"=>"hoge",
        "tag_name"=>"hoge,foo,bar",
        "ingredients_attributes"=>{
          "0"=>{"ingredient"=>"hoge", "amount"=>"hoge", "_destroy_line"=>"false"},
          "1"=>{"ingredient"=>"hoge", "amount"=>"hoge", "_destroy_line"=>"false"},
          "2"=>{"ingredient"=>"hoge", "amount"=>"hoge", "_destroy_line"=>"false"}
        },
        "how_to_makes_attributes"=>{
          "0"=>{"make_way"=>"hoge", "_destroy_line"=>"false"},
          "1"=>{"make_way"=>"hoge", "_destroy_line"=>"false"},
          "2"=>{"make_way"=>"hoge", "_destroy_line"=>"false"}
        },
        "user_id"=>user.id
      }
    end

    context "new" do
      let(:form) {described_class.new(params)}
      it { expect { subject }.to change(Recipe, :count).by(1) }

      it do
        subject

        recipe = Recipe.last
        expect(recipe.title).to eq("hoge")
        expect(recipe.content).to eq("hoge")
        expect(recipe.work).to eq("hoge")
        expect(recipe.author).to eq("hoge")
        tags = recipe.tags
        expect(tags[0].tag_name).to eq("hoge")
        expect(tags[1].tag_name).to eq("foo")
        expect(tags[2].tag_name).to eq("bar")
        expect(tags.length).to eq(3)
        ingredients = recipe.ingredients
        how_to_makes = recipe.how_to_makes
        expect(ingredients[0].ingredient).to eq("hoge")
        expect(ingredients[1].ingredient).to eq("hoge")
        expect(ingredients[2].ingredient).to eq("hoge")
        expect(ingredients[0].amount).to eq("hoge")
        expect(ingredients[1].amount).to eq("hoge")
        expect(ingredients[2].amount).to eq("hoge")
        expect(ingredients.length).to eq(3)
        expect(how_to_makes[0].make_way).to eq("hoge")
        expect(how_to_makes[1].make_way).to eq("hoge")
        expect(how_to_makes[2].make_way).to eq("hoge")
        expect(how_to_makes.length).to eq(3)
        expect(recipe.user_id).to be_present
        expect(recipe.created_at).to be_present
        expect(recipe.updated_at).to be_present
      end
    end

    context "update" do
      let(:form) {described_class.new(params, recipe: recipe)}
      let!(:recipe) {create(:recipe)}
      it { expect { subject }.not_to change(Recipe, :count) }

      it do
        subject

        recipe.reload
        expect(recipe.title).to eq("hoge")
        expect(recipe.content).to eq("hoge")
        expect(recipe.work).to eq("hoge")
        expect(recipe.author).to eq("hoge")
        tags = recipe.tags
        expect(tags[0].tag_name).to eq("hoge")
        expect(tags[1].tag_name).to eq("foo")
        expect(tags[2].tag_name).to eq("bar")
        expect(tags.length).to eq(3)
        ingredients = recipe.ingredients
        how_to_makes = recipe.how_to_makes
        expect(ingredients[0].ingredient).to eq("hoge")
        expect(ingredients[1].ingredient).to eq("hoge")
        expect(ingredients[2].ingredient).to eq("hoge")
        expect(ingredients[0].amount).to eq("hoge")
        expect(ingredients[1].amount).to eq("hoge")
        expect(ingredients[2].amount).to eq("hoge")
        expect(ingredients.length).to eq(3)
        expect(how_to_makes[0].make_way).to eq("hoge")
        expect(how_to_makes[1].make_way).to eq("hoge")
        expect(how_to_makes[2].make_way).to eq("hoge")
        expect(how_to_makes.length).to eq(3)
        expect(recipe.user_id).to be_present
        expect(recipe.created_at).to be_present
        expect(recipe.updated_at).to be_present
      end

    end

    #change -1
    context "destroy" do
      let(:form) {described_class.new(params, recipe: recipe)}
      let!(:recipe) {create(:recipe)}
      it { expect { subject }.not_to change(Recipe, :count) }
      #destroyの挙動要確認
      it do
        expect { recipe.destroy }.to change {Recipe.count}.by(-1)
      end
    end

    context "destroy_lines" do
      let(:form) {described_class.new(params)}
      let(:params) do
        {
          "title"=>"hoge",
          "content"=>"hoge",
          "work"=>"hoge",
          "author"=>"hoge",
          "tag_name"=>"hoge,foo,bar",
          "ingredients_attributes"=>{
            "0"=>{"ingredient"=>"hoge", "amount"=>"hoge", "_destroy_line"=>"false"},
            "1"=>{"ingredient"=>"hoge", "amount"=>"hoge", "_destroy_line"=>"true"},
            "2"=>{"ingredient"=>"hoge", "amount"=>"hoge", "_destroy_line"=>"true"}
          },
          "how_to_makes_attributes"=>{
            "0"=>{"make_way"=>"hoge", "_destroy_line"=>"false"},
            "1"=>{"make_way"=>"hoge", "_destroy_line"=>"true"},
            "2"=>{"make_way"=>"hoge", "_destroy_line"=>"true"}
          },
          "user_id"=>user.id
        }
      end

      it do
        subject

        recipe = Recipe.last
        ingredients = recipe.ingredients
        how_to_makes = recipe.how_to_makes
        expect(ingredients[0].ingredient).to eq("hoge")
        expect(ingredients[0].amount).to eq("hoge")
        expect(ingredients.length).to eq(1)
        expect(how_to_makes[0].make_way).to eq("hoge")
        expect(how_to_makes.length).to eq(1)
      end
    end



    context 'processing failed' do
      let(:form) {described_class.new(params)}
      context 'params missing' do
        let(:params) do
          {
            "title"=>nil,
            "content"=>nil,
            "work"=>nil,
            "author"=>nil,
            "tag_name"=>nil,
            "ingredients_attributes"=>{
              "0"=>{"ingredient"=>nil, "amount"=>nil, "_destroy_line"=>"false"},
              "1"=>{"ingredient"=>nil, "amount"=>nil, "_destroy_line"=>"false"},
              "2"=>{"ingredient"=>nil, "amount"=>nil, "_destroy_line"=>"false"}
            },
            "how_to_makes_attributes"=>{
              "0"=>{"make_way"=>nil, "_destroy_line"=>"false"},
              "1"=>{"make_way"=>nil, "_destroy_line"=>"false"},
              "2"=>{"make_way"=>nil, "_destroy_line"=>"false"}
            },
            "user_id"=>nil
          }
        end

        it do
          subject
          expect(form.errors.full_messages).to contain_exactly(
            "Title can't be blank",
            "Content can't be blank",
            "Work can't be blank",
            "Author can't be blank",
            "Tag name can't be blank",
            "Ingredient can't be blank",
            "Ingredient can't be blank",
            "Ingredient can't be blank",
            "Amount can't be blank",
            "Amount can't be blank",
            "Amount can't be blank",
            "Make way can't be blank",
            "Make way can't be blank",
            "Make way can't be blank",
            "User can't be blank"
          )
        end
      end
      context "params is too long" do
        let(:params) do
          {
            "title"=>"a" * 51,
            "content"=>"a" * 256,
            "work"=>"a" * 51,
            "author"=>"a" * 51,
            "tag_name"=>"a" * 51,
            "ingredients_attributes"=>{
              "0"=>{"ingredient"=>"a" * 51, "amount"=>"a" * 51, "_destroy_line"=>"false"},
              "1"=>{"ingredient"=>"a" * 51, "amount"=>"a" * 51, "_destroy_line"=>"false"},
              "2"=>{"ingredient"=>"a" * 51, "amount"=>"a" * 51, "_destroy_line"=>"false"}
            },
            "how_to_makes_attributes"=>{
              "0"=>{"make_way"=>"a" * 256, "_destroy_line"=>"false"},
              "1"=>{"make_way"=>"a" * 256, "_destroy_line"=>"false"},
              "2"=>{"make_way"=>"a" * 256, "_destroy_line"=>"false"}
            },
            "user_id"=>user.id
          }
        end
        it do
          subject
          expect(form.errors.full_messages).to contain_exactly(
            "Title is too long (maximum is 50 characters)",
            "Content is too long (maximum is 255 characters)",
            "Author is too long (maximum is 50 characters)",
            "Work is too long (maximum is 50 characters)",
            "Tag name is too long (maximum is 50 characters)",
            "Ingredient is too long (maximum is 50 characters)",
            "Ingredient is too long (maximum is 50 characters)",
            "Ingredient is too long (maximum is 50 characters)",
            "Amount is too long (maximum is 50 characters)",
            "Amount is too long (maximum is 50 characters)",
            "Amount is too long (maximum is 50 characters)",
            "Make way is too long (maximum is 255 characters)",
            "Make way is too long (maximum is 255 characters)",
            "Make way is too long (maximum is 255 characters)"
          )
        end
      end
    end
  end
end