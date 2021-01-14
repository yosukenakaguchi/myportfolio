class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    super + error(method)
  end

  def text_area(method, options = {})
    super + error(method)
  end

  #ネストした要素であるtext_field(ingredients_fields及びhow_to_makes_fields)へのアクセスが分からない
  def fields_for(method, record_object = nil, options = {}, &block)
    super + error(method)
  end

  private

  def error(method)
    error_html(error_message(method))
  end

  def error_message(method)
    (@object.errors[method].size > 0) ? I18n.t("activemodel.attributes.#{@object.model_name.singular}.#{method}") + @object.errors[method].first : ""
  end

  def error_html(msg)
    return "" unless msg.present?

    @template.content_tag(:div, class: "has-error") do
      @template.concat (@template.content_tag(:span, class: "help-block") do
        msg
      end)
    end
  end
end