module EnumHelper
  def translate_role(role)
    I18n.t("activerecord.attributes.user.roles.#{role}")
  end

  def roles_for_select
    User.roles.keys.map do |role|
      [translate_role(role), role]
    end
  end

  def translate_kind(kind)
    I18n.t("activerecord.attributes.operation.kinds.#{kind}")
  end

  def kinds_for_select
    # adding operations is not concerned with first three operation types, so they're dropped from the select box
    Operation.kinds.keys.drop(3).map do |kind|
      [translate_kind(kind), kind]
    end
  end
end
