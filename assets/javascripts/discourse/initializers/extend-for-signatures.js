import { withPluginApi } from "discourse/lib/plugin-api";
import { isEmpty } from "@ember/utils";

function getImageUrl(str) {
  let url = "/plugins/discourse-signatures-pkmn/images";
  let classes = "";

  str = str.replace(".pokesprite.", "");
  let splits = str.split(".");
  let shiny = false;

  if (splits[0] === "pokemon") {
      classes += " signature-pokemon";
      const shinyIndex = splits.indexOf("shiny");
      if (shinyIndex !== -1) {
          shiny = true;

          splits[0] = "pokemon/shiny";
          splits.splice(shinyIndex, 1);
      }
  } else {
      classes += " signature-item";
  }

  splits.forEach(split => {
      url += "/" + split;
  });

  url += ".png";
  return { url, classes, shiny };
}

function attachSignature(api, siteSettings) {
  api.includePostAttributes("signature_pkmn_1");
  api.includePostAttributes("signature_pkmn_2");
  api.includePostAttributes("signature_pkmn_3");
  api.includePostAttributes("signature_pkmn_4");
  api.includePostAttributes("signature_pkmn_5");
  api.includePostAttributes("signature_pkmn_6");

  api.decorateWidget("post-contents:after-cooked", (dec) => {
    const attrs = dec.attrs;
    const currentUser = api.getCurrentUser();
    let enabled;

    if (currentUser) {
      enabled =
        currentUser.get("custom_fields.see_signatures") ??
        siteSettings.signatures_visible_by_default;
    } else {
      enabled = siteSettings.signatures_visible_for_guests;
    }
    if (enabled) {

      function createSignatureElement(attr) {
        if (isEmpty(attr)) {
            return dec.h("div.signature-slot.signature-slot-empty");
        } else {
            const imageData = getImageUrl(attr);
            const imgElement = dec.h("img", { className: imageData.classes, src: imageData.url, alt: "" });
            const rectangleElement = dec.h("div.user-signature-rectangle");
    
            let children = [imgElement, rectangleElement];
            if (imageData.shiny) {
                children.unshift(dec.h("div.shiny-effect"));
            }
            return dec.h("div.signature-slot", children);
        }
      }

      return [
        //dec.h("hr"),
        dec.h("div.user-signature", [
          createSignatureElement(attrs.signature_pkmn_1),
          createSignatureElement(attrs.signature_pkmn_2),
          createSignatureElement(attrs.signature_pkmn_3),
          createSignatureElement(attrs.signature_pkmn_4),
          createSignatureElement(attrs.signature_pkmn_5),
          createSignatureElement(attrs.signature_pkmn_6)
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
      withPluginApi("0.8", (api) => {
        attachSignature(api, siteSettings);
        addSetting(api, siteSettings);
      });
    }
  },
};