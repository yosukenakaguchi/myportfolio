class RecipeForm
  include ActiveModel::Model

  attr_accessor :title, :work, :author, :content, :user_id, :tag_name, :image

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
      @ingredients_attributes = attributes.map do |_, attribute|
        Ingredient.new(attribute)
      end
    end
  end

  concerning :HowToMakesBuilder do
    attr_reader :how_to_makes_attributes

    def how_to_makes
      @how_to_makes_attributes ||= HowToMake.new
    end

    def how_to_makes_attributes=(attributes)
      @how_to_makes_attributes = attributes.map do |_, attribute|
        HowToMake.new(attribute)
      end
    end
  end

  def initialize(attributes = nil, recipe: Recipe.new)
    @recipe = recipe
    set_ingredients_attributes
    set_how_to_makes_attributes
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return if invalid?
    ActiveRecord::Base.transaction do
      tags = split_tag_name.map { |name| Tag.find_or_create_by!(tag_name: name) }
      recipe.update(title: title, work: work, author: author, content: content, tags: tags, user_id: user_id, image: image, ingredients: ingredients_attributes, how_to_makes: how_to_makes_attributes)
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
    }
  end

  def set_ingredients_attributes
    if recipe.persisted?
      @ingredients_attributes = recipe.ingredients
    else
      self.ingredients_attributes = [{},{},{}]
    end
  end

  def set_how_to_makes_attributes
    if recipe.persisted?
      @how_to_makes_attributes = recipe.how_to_makes
    else
      self.how_to_makes_attributes = [{},{},{}]
    end
  end

  def split_tag_name
    tag_name.split(',')
  end
end