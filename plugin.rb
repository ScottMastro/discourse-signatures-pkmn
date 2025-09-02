# frozen_string_literal: true

# name: discourse-signatures-pkmn
# about: Adds PKMN style signatures to Discourse posts
# version: 1.2
# authors: ScottMastro
# url: https://github.com/ScottMastro/discourse-signatures-pkmn
# transpile_js: true

enabled_site_setting :signatures_enabled

# Adds a custom user field to the serialized current user object
# (ie. so the front-end can see it)
DiscoursePluginRegistry.serialized_current_user_fields << "see_signatures"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_1"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_2"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_3"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_4"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_5"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_pkmn_6"

after_initialize do
  # Tells Discourse how to treat a user’s custom field in the DB
  User.register_custom_field_type("see_signatures", :boolean)
  User.register_custom_field_type("signature_pkmn_1", :text)
  User.register_custom_field_type("signature_pkmn_2", :text)
  User.register_custom_field_type("signature_pkmn_3", :text)
  User.register_custom_field_type("signature_pkmn_4", :text)
  User.register_custom_field_type("signature_pkmn_5", :text)
  User.register_custom_field_type("signature_pkmn_6", :text)

  # Allow for default value for the setting
  add_to_class(:user, :see_signatures) do
    if custom_fields["see_signatures"] != nil
      custom_fields["see_signatures"]
    else
      SiteSetting.signatures_visible_by_default
    end
  end

  add_to_serializer(:user, :see_signatures) { object.see_signatures }

  # Marks user custom fields as editable via the preferences UI
  register_editable_user_custom_field :see_signatures
  register_editable_user_custom_field :signature_pkmn_1
  register_editable_user_custom_field :signature_pkmn_2
  register_editable_user_custom_field :signature_pkmn_3
  register_editable_user_custom_field :signature_pkmn_4
  register_editable_user_custom_field :signature_pkmn_5
  register_editable_user_custom_field :signature_pkmn_6

  # Allows a custom field to be visible to anyone, not just staff
  allow_public_user_custom_field :signature_pkmn_1
  allow_public_user_custom_field :signature_pkmn_2
  allow_public_user_custom_field :signature_pkmn_3
  allow_public_user_custom_field :signature_pkmn_4
  allow_public_user_custom_field :signature_pkmn_5
  allow_public_user_custom_field :signature_pkmn_6

  # Adds fields to the PostSerializer JSON
  add_to_serializer(:post, :signature_pkmn_1) do
    object.user.custom_fields["signature_pkmn_1"] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_2) do
    object.user.custom_fields["signature_pkmn_2"] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_3) do
    object.user.custom_fields["signature_pkmn_3"] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_4) do
    object.user.custom_fields["signature_pkmn_4"] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_5) do
    object.user.custom_fields["signature_pkmn_5"] if object.user
  end
  add_to_serializer(:post, :signature_pkmn_6) do
    object.user.custom_fields["signature_pkmn_6"] if object.user
  end
end

register_asset "stylesheets/common/signatures.scss"
register_asset "stylesheets/mobile/mobile.scss", :mobile
