import { classNames } from "@ember-decorators/component";
import DropdownSelectBox from "select-kit/components/dropdown-select-box";
import {
  pluginApiIdentifiers,
  selectKitOptions,
} from "select-kit/components/select-kit";

@classNames("pkmn-select-box")
@selectKitOptions({
  filterable: true,
  autoFilterable: false,
  valueProperty: "id",
  nameProperty: "name",
  showCaret: true,
  caretUpIcon: "caret-up",
  caretDownIcon: "caret-down",
  showFullTitle: true,
})
@pluginApiIdentifiers(["pkmn-select-box"])
export default class PkmnSelectBox extends DropdownSelectBox {
  search(term = "") {
    let list = this.content || [];
    term = (term || "").toLowerCase();

    if (!term) {
      return list
        .filter((o) => o.id.toLowerCase().includes("pokemon."))
        .slice(0, 50);
    }

    return list.filter((o) => o.id.toLowerCase().includes(term)).slice(0, 50);
  }
}
