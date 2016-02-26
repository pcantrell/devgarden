module StringArrayAttribute
  extend ActiveSupport::Concern

  class_methods do
    def exposes_array_as_text(attr_name, to_text: IDENTITY, from_text: IDENTITY)
      define_method "#{attr_name}_as_text" do
        send(attr_name).map(&to_text).join("\n")
      end

      define_method "#{attr_name}_as_text=" do |text|
        send("#{attr_name}=", text.split(/\s+/).reject(&:blank?).map(&from_text))
      end
    end
  end

private

  IDENTITY = ->(x) { x }

end
