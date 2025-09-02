import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input } from "@ember/component";
import { array , concat, fn } from "@ember/helper";
import { action, get } from "@ember/object";
import { htmlSafe } from "@ember/template";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";
import PkmnSelectBox from "../../components/pkmn-select-box";

export default class PkmnSignaturePreferences extends Component {
  static shouldRender(_args, context) {
    return context.siteSettings.signatures_enabled;
  }

  @tracked options = [];
  @tracked slots = {};

  constructor() {
    super(...arguments);
    this.slots = { ...this.args.outletArgs.model.custom_fields };
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

  @action
  updateSlot(slot, value) {
    this.slots = {
      ...this.slots,
      [`signature_pkmn_${slot}`]: value,
    };
    this.args.outletArgs.model.custom_fields = { ...this.slots };

    console.log(`Updating slot ${slot} to ${value}`, this.args.outletArgs.model.custom_fields);

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

    {{!-- Loop through 6 slots --}}
    {{#each (array 1 2 3 4 5 6) as |slot|}}
      <div class="control-group signatures">
        <label class="control-label">
          {{i18n (concat "signatures.my_pkmn_" slot)}}
        </label>
        <div class="controls flex-row">
          <PkmnSelectBox
            @content={{this.options}}
            @value={{get this.slots (concat "signature_pkmn_" slot)}}
            @onChange={{fn this.updateSlot slot}}
          />
          {{#if (get this.slots (concat "signature_pkmn_" slot))}}
            <DButton
              @action={{fn this.updateSlot slot ""}}
              @icon="xmark"
              @title="delete"
              class="destroy btn-danger pkmn-delete-button"
            />
          {{/if}}
        </div>
      </div>
    {{/each}}
  </template>
}
