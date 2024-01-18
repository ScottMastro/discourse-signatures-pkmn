# frozen_string_literal: true

# name: discourse-signatures-pkmn
# about: Adds PKMN style signatures to Discourse posts
# version: 1.1.0
# authors: ScottMastro
# url: https://github.com/ScottMastro/discourse-signatures-pkmn
# transpile_js: true

enabled_site_setting :signatures_enabled

DiscoursePluginRegistry.serialized_current_user_fields << "see_signatures"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_1"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_2"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_3"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_4"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_5"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_6"

after_initialize do
  User.register_custom_field_type('see_signatures', :boolean)
  User.register_custom_field_type('signature_pkmn_1', :text)
  User.register_custom_field_type('signature_pkmn_2', :text)
  User.register_custom_field_type('signature_pkmn_3', :text)
  User.register_custom_field_type('signature_pkmn_4', :text)
  User.register_custom_field_type('signature_pkmn_5', :text)
  User.register_custom_field_type('signature_pkmn_6', :text)

  # add to class and serializer to allow for default value for the setting
  add_to_class(:user, :see_signatures) do
    if custom_fields['see_signatures'] != nil
      custom_fields['see_signatures']
    else
      SiteSetting.signatures_visible_by_default
    end
  end

  add_to_serializer(:user, :see_signatures) do
    object.see_signatures
  end

  register_editable_user_custom_field [:see_signatures, :signature_pkmn_1, :signature_pkmn_2, :signature_pkmn_3, :signature_pkmn_4, :signature_pkmn_5, :signature_pkmn_6]

  allow_public_user_custom_field :signature_cooked
  allow_public_user_custom_field :signature_pkmn_1
  allow_public_user_custom_field :signature_pkmn_2
  allow_public_user_custom_field :signature_pkmn_3
  allow_public_user_custom_field :signature_pkmn_4
  allow_public_user_custom_field :signature_pkmn_5
  allow_public_user_custom_field :signature_pkmn_6

  add_to_serializer(:post, :signature_pkmn_1) do
      object.user.custom_fields['signature_pkmn_1'] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_2) do
      object.user.custom_fields['signature_pkmn_2'] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_3) do
      object.user.custom_fields['signature_pkmn_3'] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_4) do
      object.user.custom_fields['signature_pkmn_4'] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_5) do
      object.user.custom_fields['signature_pkmn_5'] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_6) do
      object.user.custom_fields['signature_pkmn_6'] if object.user
  end

end

register_asset "stylesheets/common/signatures.scss"
register_asset 'stylesheets/mobile/mobile.scss', :mobile
