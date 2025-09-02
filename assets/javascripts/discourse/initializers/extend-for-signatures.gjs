import Component from "@glimmer/component";
import { service } from "@ember/service";
import { isEmpty } from "@ember/utils";
import { withPluginApi } from "discourse/lib/plugin-api";

class UserSignature extends Component {
  static shouldRender(args, context) {
    const siteSettings = context.siteSettings;
    const currentUser = context.currentUser;

    if (!siteSettings.signatures_enabled) {
      return false;
    }

    if (currentUser) {
      return (
        currentUser.custom_fields?.see_signatures ??
        siteSettings.signatures_visible_by_default
      );
    } else {
      return siteSettings.signatures_visible_for_guests;
    }
  }

  @service siteSettings;
  @service currentUser;

  get slots() {
    const post = this.args.post;
    return [
      post.signature_pkmn_1,
      post.signature_pkmn_2,
      post.signature_pkmn_3,
      post.signature_pkmn_4,
      post.signature_pkmn_5,
      post.signature_pkmn_6,
    ].map((attr) => this._makeSlot(attr));
  }

  _makeSlot(attr) {
    if (isEmpty(attr)) {
      return { empty: true };
    } else {
      return this._getImageData(attr);
    }
  }

  _getImageData(str) {
    let url = "/plugins/discourse-signatures-pkmn/images";
    let classes = "";
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

    splits.forEach((s) => (url += "/" + s));
    url += ".png";

    return { url, classes, shiny, empty: false };
  }

  <template>
    <div class="user-signature">
      {{#each this.slots as |slot|}}
        {{#if slot.empty}}
          <div class="signature-slot signature-slot-empty"></div>
        {{else}}
          <div class="signature-slot">
            {{#if slot.shiny}}
              <div class="shiny-effect"></div>
            {{/if}}
            <img class={{slot.classes}} src={{slot.url}} alt="" />
            <div class="user-signature-rectangle"></div>
          </div>
        {{/if}}
      {{/each}}
    </div>
  </template>
}

export default {
  name: "extend-for-signatures",
  initialize() {
    withPluginApi((api) => {
      api.addTrackedPostProperties(
        "signature_pkmn_1",
        "signature_pkmn_2",
        "signature_pkmn_3",
        "signature_pkmn_4",
        "signature_pkmn_5",
        "signature_pkmn_6"
      );

      api.renderInOutlet("post-menu__before", UserSignature);
    });
  },
};
