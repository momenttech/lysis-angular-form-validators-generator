// This file should not be modified, as it can be overwritten by the generator.
// The '{{ ucc resource.title }}Validators' class is here for customizations and will not be touched.

import { Validators } from '@angular/forms';
import { CustomValidators } from 'ng2-validation';
import { FormGroupValidators } from '../tools/FormGroupValidators';

export class {{ ucc resource.title }}ValidatorsBase extends FormGroupValidators {
  {{#each resource.fields}}
    {{ name }} = {{ validators this }};
  {{/each}}
}
