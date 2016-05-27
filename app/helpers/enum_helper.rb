module EnumHelper

  def translate_role(role)
    I18n.t("activerecord.attributes.user.roles.#{role}")
  end

  def roles_for_select
    User.roles.keys.map do |role|
      [translate_role(role), role]
    end
  end
end
