class RecipeForm
  include ActiveModel::Model

  attr_accessor :title, :work, :author, :content, :user_id, :tag_name, :image, :ingredients, :how_to_makes

  with_options presence: true do
    validates :title, length: { maximum: 50 }
    validates :work, length: { maximum: 50 }
    validates :author, length: { maximum: 50 }
    validates :content, length: { maximum: 255 }
    validates :user_id
  end

  delegate :persisted?, to: :recipe

  concerning :IngredientsBuilder do
    attr_reader :ingredients_attributes

    def ingredients
      @ingredients_attributes ||= Ingredient.new
    end

    def ingredients_attributes=(attributes)
      @ingredients_attributes = Ingredient.new(attributes)
    end
  end

  concerning :HowToMakesBuilder do
    attr_reader :how_to_makes_attributes

    def how_to_makes
      @how_to_makes_attributes ||= HowToMake.new
    end

    def how_to_makes_attributes=(attributes)
      @how_to_makes_attributes = HowToMake.new(attributes)
    end
  end

  def initialize(attributes = nil, recipe: Recipe.new)
    @recipe = recipe
    3.times {@recipe.ingredients.build}
    3.times {@recipe.how_to_makes.build}
    p "hoge"
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return if invalid?
    ActiveRecord::Base.transaction do
      tags = split_tag_name.map { |name| Tag.find_or_create_by!(tag_name: name) }
      build_asscociations
      recipe.update(title: title, work: work, author: author, content: content, tags: tags, user_id: user_id, image: image)
    end
  end

  def to_model
    recipe
  end

  private

  attr_reader :recipe

  def default_attributes
    {
      title: recipe.title,
      work: recipe.work,
      author: recipe.author,
      content: recipe.content,
      user_id: recipe.user_id,
      tag_name: recipe.tags.pluck(:tag_name).join(','),
      image: recipe.image,
      ingredients: recipe.ingredients,
      how_to_makes: recipe.how_to_makes
    }
  end

  def build_asscociations
    recipe.ingredients << ingredients unless ingredients_attributes.nil?
    recipe.how_to_makes << how_to_makes unless how_to_makes_attributes.nil?
  end

  def split_tag_name
    tag_name.split(',')
  end
end