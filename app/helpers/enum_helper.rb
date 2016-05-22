module EnumHelper

  def t_enum(instance, enum)
    value = instance.send(enum);
    t_enum_class(instance.class, enum, value)
  end

  def t_enum_class(class_name, enum, value)
    unless value.blank?
      I18n.t("activerecord.enums.#{class_name.to_s.demodulize.underscore}.#{enum}.#{value}")
    end
  end
end
