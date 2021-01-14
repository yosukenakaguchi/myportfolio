module ApplicationHelper
  def full_title(page_title = '')
    base_title = "映画・文学めし"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def link_to_add_fields(f, association, new_object)
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("shared/#{association.to_s.pluralize}_fields", f: builder)
    end
    # This renders a simple link, but passes information into `data` attributes.
    link_to('#', class: "add_fields", data: { id: id, fields: fields.delete("\n") }) do
      '<i class="fa fa-plus-circle"></i><span class="add-nav"> 行を追加する</span>'.html_safe
    end
  end

  def link_to_remove_field(f, _options = {})
    # _destroy の hiddenフィールドと削除ボタンを設置
    f.hidden_field(:_destroy_line) + link_to('#', class: "remove_field") do
      '<i class="fa fa-times-circle"></i>'.html_safe
    end
  end
end
