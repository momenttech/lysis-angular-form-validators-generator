import { FormService } from './tools/Form.service';
import { Form } from './tools/Form';
import { ValidationTypes } from './tools/ValidationTypes';
import { FormGroupValidationMatcherBase } from './FormGroupValidationMatcherBase';

{{#each resources}}
import { {{ ucc title }}Validators } from './{{ ucc title }}Validators';
{{/each}}

export {
  FormService,
  Form,
  ValidationTypes,
  FormGroupValidationMatcherBase,

  {{#each resources}}
  {{ ucc title }}Validators,
  {{/each}}
}
