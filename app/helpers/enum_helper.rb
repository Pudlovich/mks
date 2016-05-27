module EnumHelper

  def translate_enum(instance, enum)
    value = instance.send(enum);
    translate_enum_class(instance.class, enum, value)
  end

  def translate_enum_class(class_name, enum, value)
    unless value.blank?
      I18n.t("activerecord.enums.#{class_name.to_s.demodulize.underscore}.#{enum}.#{value}")
    end
  end
end
