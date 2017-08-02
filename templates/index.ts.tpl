// This file should not be modified, as it can be overwritten by the generator.
import { FormService } from './tools/Form.service';
import { Form } from './tools/Form';
import { ValidationTypes } from './tools/ValidationTypes';
import { AppValidators } from './app-validators';
import { FormGroupValidationMatcherBase } from './FormGroupValidationMatcherBase';

{{#each resources}}
import { {{ ucc title }}Validators } from './{{ ucc title }}Validators';
{{/each}}

export {
  FormService,
  Form,
  ValidationTypes,
  AppValidators,
  FormGroupValidationMatcherBase,

  {{#each resources}}
  {{ ucc title }}Validators,
  {{/each}}
}
