class RecipeForm
  include ActiveModel::Model

  attr_accessor :title, :work, :author, :content, :user_id, :tag_name, :image

  with_options presence: true do
    validates :title, length: { maximum: 50 }
    validates :work, length: { maximum: 50 }
    validates :author, length:  { maximum: 50 }
    validates :content, length: { maximum: 255 }
    validates :user_id
    validates :tag_name
  end
  validate :if_recipe_form_does_not_have_ingredient
  validate :if_ingredient_is_more_than_51_words
  validate :if_recipe_form_does_not_have_amount
  validate :if_amount_is_more_than_51_words
  validate :if_recipe_form_does_not_have_make_way
  validate :if_make_way_is_more_than_256_words

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
      destroy_lines
      recipe.update(title: title,
                    work: work,
                    author: author,
                    content: content,
                    tags: tags,
                    user_id: user_id,
                    image: image,
                    ingredients: ingredients_attributes,
                    how_to_makes: how_to_makes_attributes
                    )
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
      image: recipe.image
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

  #今後の課題として、現状は:_destroy_lineカラムを用意しているが、データベースへ保存する必要がないため仮属性として実装すること
  def destroy_lines
    @ingredients_attributes = @ingredients_attributes.each.reject { |ingredients_attribute| ingredients_attribute[:_destroy_line] == true}
    @how_to_makes_attributes = @how_to_makes_attributes.each.reject { |how_to_makes_attribute| how_to_makes_attribute[:_destroy_line] == true}
  end

  def split_tag_name
    tag_name.split(',')
  end

  def if_recipe_form_does_not_have_ingredient
    destroy_lines
    for a in ingredients_attributes do
      if a.ingredient.blank?
        errors.add(:ingredient, "can't be blank")
      end
    end
  end

  def if_ingredient_is_more_than_51_words
    destroy_lines
    for a in ingredients_attributes do
      if a.ingredient.length > 50
        errors.add(:ingredient, "can't be more than 51 words")
      end
    end
  end

  def if_recipe_form_does_not_have_amount
    destroy_lines
    for a in ingredients_attributes do
      if a.amount.blank?
        errors.add(:amount, "can't be blank")
      end
    end
  end

  def if_amount_is_more_than_51_words
    destroy_lines
    for a in ingredients_attributes do
      if a.amount.length > 50
        errors.add(:amount, "can't be more than 51 words")
      end
    end
  end

  def if_recipe_form_does_not_have_make_way
    destroy_lines
    for a in how_to_makes_attributes do
      if a.make_way.blank?
        errors.add(:make_way, "can't be blank")
      end
    end
  end

  def if_make_way_is_more_than_256_words
    destroy_lines
    for a in how_to_makes_attributes do
      if a.make_way.length > 256
        errors.add(:make_way, "can't be more than 256 words")
      end
    end
  end
end