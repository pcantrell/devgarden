module StringArrayAttribute
  extend ActiveSupport::Concern

  class_methods do
    def exposes_string_array_as_text(attr_name)
      define_method "#{attr_name}_as_text" do
        send(attr_name).join("\n")
      end

      define_method "#{attr_name}_as_text=" do |text|
        send("#{attr_name}=", text.split(/\s+/).reject(&:blank?))
      end
    end
  end

end
