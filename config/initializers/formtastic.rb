Formtastic::FormBuilder.action_class_finder = Formtastic::ActionClassFinder
Formtastic::FormBuilder.input_class_finder = Formtastic::InputClassFinder

Formtastic::FormBuilder.default_text_area_height = 1

Formtastic::FormBuilder.required_string = ""
Formtastic::FormBuilder.optional_string = "<abbr class='validation optional'>Optional</abbr>".html_safe

Formtastic::FormBuilder.default_hint_class = "inline-hint"
Formtastic::FormBuilder.default_inline_error_class = "inline-error"
# Formtastic::FormBuilder.default_error_list_class = "errors"

class Formtastic::FormBuilder
  def save_button(
      title_for_new_record: "Create",
      title_for_existing_record: "Save",
      html: {})

    title = if object_is_new?
      title_for_new_record
    else
      title_for_existing_record
    end
    submit(title, html)
  end

private

  def object_is_new?
    object.respond_to?(:new_record?) && object.new_record?
  end

end
