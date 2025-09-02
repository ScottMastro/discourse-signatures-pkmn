import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input } from "@ember/component";
import { htmlSafe } from "@ember/template";
import { i18n } from "discourse-i18n";
import PkmnSelectBox from "../../components/pkmn-select-box";

export default class PkmnSignaturePreferences extends Component {
  static shouldRender(_args, context) {
    return context.siteSettings.signatures_enabled;
  }

  @tracked options = [];

  constructor() {
    super(...arguments);
    this.loadPKMN();
  }

  async fetchPKMN() {
    const resp = await fetch("/plugins/discourse-signatures-pkmn/pkmn.json");

    if (!resp.ok) {
      throw new Error(`HTTP error! status: ${resp.status}`);
    }

    const list = await resp.json();

    return list.map((item) => {
      const url = `/plugins/discourse-signatures-pkmn${item.url}`;
      return {
        ...item,
        url,
        id: item.id,
        name: htmlSafe(
          `<div class="pkmn-row"><img src="${url}" class="pkmn-thumb"/> ${item.id}</div>`
        ),
      };
    });
  }

  async loadPKMN(retries = 3, delay = 1000) {
    try {
      this.options = await this.fetchPKMN();
    } catch (e) {
      if (retries > 0) {
        setTimeout(() => this.loadPKMN(retries - 1, delay), delay);
      } else {
        console.error("Giving up on fetching Pokémon list.", e.message);
      }
    }
  }

  <template>
    <div class="control-group signatures">
      <label class="control-label">
        {{i18n "signatures.enable_signatures"}}
      </label>
      <div class="controls">
        <label class="checkbox-label">
          <Input
            @type="checkbox"
            @checked={{@outletArgs.model.custom_fields.see_signatures}}
          />
          {{i18n "signatures.show_signatures"}}
        </label>
      </div>
    </div>

    <div class="control-group signatures">
      <label class="control-label">{{i18n "signatures.my_pkmn_1"}}</label>
      <div class="controls">
        <PkmnSelectBox
          @content={{this.options}}
          @value={{@outletArgs.model.custom_fields.signature_pkmn_1}}
        />
      </div>
    </div>

    <div class="control-group signatures">
      <label class="control-label">{{i18n "signatures.my_pkmn_2"}}</label>
      <div class="controls">
        <PkmnSelectBox
          @content={{this.options}}
          @value={{@outletArgs.model.custom_fields.signature_pkmn_2}}
        />
      </div>
    </div>

    <div class="control-group signatures">
      <label class="control-label">{{i18n "signatures.my_pkmn_3"}}</label>
      <div class="controls">
        <PkmnSelectBox
          @content={{this.options}}
          @value={{@outletArgs.model.custom_fields.signature_pkmn_3}}
        />
      </div>
    </div>

    <div class="control-group signatures">
      <label class="control-label">{{i18n "signatures.my_pkmn_4"}}</label>
      <div class="controls">
        <PkmnSelectBox
          @content={{this.options}}
          @value={{@outletArgs.model.custom_fields.signature_pkmn_4}}
        />
      </div>
    </div>

    <div class="control-group signatures">
      <label class="control-label">{{i18n "signatures.my_pkmn_5"}}</label>
      <div class="controls">
        <PkmnSelectBox
          @content={{this.options}}
          @value={{@outletArgs.model.custom_fields.signature_pkmn_5}}
        />
      </div>
    </div>

    <div class="control-group signatures">
      <label class="control-label">{{i18n "signatures.my_pkmn_6"}}</label>
      <div class="controls">
        <PkmnSelectBox
          @content={{this.options}}
          @value={{@outletArgs.model.custom_fields.signature_pkmn_6}}
        />
      </div>
    </div>
  </template>
}
