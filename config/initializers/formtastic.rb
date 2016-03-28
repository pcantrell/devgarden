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
      new_record_title: "Create",
      existing_record_title: "Save",
      css_class: nil)

    title = if object_is_new?
      new_record_title
    else
      existing_record_title
    end
    submit(title, class: css_class)
  end

  def tabbed_save_button
    save_button(
      existing_record_title: 'Next',
      css_class: ('next-tab' unless object_is_new?))
  end

private

  def object_is_new?
    object.respond_to?(:new_record?) && object.new_record?
  end

end
