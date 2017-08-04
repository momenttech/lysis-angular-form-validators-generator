// This file should not be modified, as it can be overwritten by the generator.
// The 'FormGroupValidationMatcher' class is here for customizations and will not be touched.

import { ValidationTypes } from './tools/ValidationTypes';

{{#each resources}}
import { {{ ucc title }} } from '{{ ../classPath }}/{{ ucc title }}';
import { {{ ucc title }}Validators } from './{{ ucc title }}Validators';
{{/each}}

export class FormGroupValidationMatcherBase {
  protected items: {[itemType: string ]: ValidationTypes};

  constructor() {
    this.setBaseItems();
    this.setItems();
  }

  setItems() {}

  setBaseItems() {
    this.items = {};
{{#each resources}}
    this.items[{{ ucc title }}.name] = {itemClass: {{ ucc title }}, validator: {{ ucc title }}Validators};
{{/each}}
  }

  get(itemType: string): ValidationTypes {
    if (!this.items[itemType]) {
      throw new Error('Form group validator not found for "' + itemType + '"');
    }
    return this.items[itemType];
  }
}
