import { withPluginApi } from "discourse/lib/plugin-api";
import RawHtml from "discourse/widgets/raw-html";
import { isEmpty } from "@ember/utils";

function attachSignature(api, siteSettings) {
  api.includePostAttributes("signature_pkmn_1");
  api.includePostAttributes("signature_pkmn_2");
  api.includePostAttributes("signature_pkmn_3");
  api.includePostAttributes("signature_pkmn_4");
  api.includePostAttributes("signature_pkmn_5");
  api.includePostAttributes("signature_pkmn_6");

  api.decorateWidget("post-contents:after-cooked", (dec) => {
    const attrs = dec.attrs;
    if (isEmpty(attrs.signature_pkmn_1) && isEmpty(attrs.signature_pkmn_2) &&
        isEmpty(attrs.signature_pkmn_3) && isEmpty(attrs.signature_pkmn_4) &&
        isEmpty(attrs.signature_pkmn_5) && isEmpty(attrs.signature_pkmn_6)) {
      return;
    }

    const currentUser = api.getCurrentUser();
    let enabled;

    if (currentUser) {
      enabled =
        currentUser.get("custom_fields.see_signatures") ??
        siteSettings.signatures_visible_by_default;
    } else {
      enabled = siteSettings.signatures_visible_by_default;
    }
    if (enabled) {
        return [
          //dec.h("hr"),
          dec.h("div.user-signature", [
             dec.h("span".concat(attrs.signature_pkmn_1)),
             dec.h("span".concat(attrs.signature_pkmn_2)),
             dec.h("span".concat(attrs.signature_pkmn_3)),
             dec.h("span".concat(attrs.signature_pkmn_4)),
             dec.h("span".concat(attrs.signature_pkmn_5)),
             dec.h("span".concat(attrs.signature_pkmn_6))
	  ])
        ];
    }
  });
}

function addSetting(api) {
  api.modifyClass("controller:preferences/profile", {
    pluginId: "discourse-signatures-pkmn",

    actions: {
      save() {
        this.set(
          "model.custom_fields.see_signatures",
          this.get("model.see_signatures")
        );
        this.get("saveAttrNames").push("custom_fields");
        this._super();
      },
    },
  });
}

export default {
  name: "extend-for-signatures",
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    if (siteSettings.signatures_enabled) {
      withPluginApi("0.1", (api) => attachSignature(api, siteSettings));
      withPluginApi("0.1", (api) => addSetting(api, siteSettings));
    }
  },
};
