import { FormBuilder, FormGroup } from '@angular/forms';
import { CustomValidators } from 'ng2-validation';

import { FormGroupValidators } from './FormGroupValidators';
import { ValidationTypes } from './ValidationTypes';
import { FormGroupValidationMatcher } from '../FormGroupValidationMatcher';
import { FormGroupValidationMatcherBase } from '../FormGroupValidationMatcherBase';

export class Form<T> {
  protected formGroup: FormGroup;
  protected types: ValidationTypes;
  protected validationMatcher: FormGroupValidationMatcherBase;

  constructor(
    private formBuilder: FormBuilder,
    item?: Object,
    validationTypes?: ValidationTypes,
    validationMatcher?: FormGroupValidationMatcherBase
  ) {
    if (validationMatcher) {
      this.validationMatcher = validationMatcher;
    } else {
      this.validationMatcher = new FormGroupValidationMatcher();
    }
    if (item) this.set(item, validationTypes);
  }

  get group(): FormGroup { return this.formGroup; }

  set(item: Object, validationTypes?: ValidationTypes): void {
    if (validationTypes) {
      this.types = validationTypes;
    } else {
      this.types = this.validationMatcher.get(item.constructor.name);
    }
    this.formGroup = this.formBuilder.group(this.setFormGroupValues(item, new this.types.validator()));
  }

  get(): T {
    var emptyObject = new this.types.itemClass();
    var validator = new this.types.validator();
    var result = Object.assign(emptyObject, this.formGroup.value);
    for (let property in result) {
      if (Array.isArray(validator[property]) && validator[property].indexOf(CustomValidators.date) !== -1) {
        if (!result[property]) result[property] = null;
      }
    }
    return result;
  }

  displayErrors(): void {
    if (!this.formGroup.valid) {
      for (let controlName in this.formGroup.controls) {
        let control = this.formGroup.controls[controlName];
        if (control.invalid && !control.touched) control.markAsTouched();
      }
    }
  }

  protected setFormGroupValues(item: Object, group: FormGroupValidators): any {
    var groupForBuilder = {};
    for (let property in group) {
      let value: string = '';
      if (item[property]) {
        if (item[property] instanceof Date) {
          value = this.formatDate(item[property]);
        } else {
          value = item[property];
        }
      }
      if (group[property]) {
        // property: [value, constraint] or property: [value, [constraints]]
        groupForBuilder[property] = [value, group[property]];
      } else {
        // property: value
        groupForBuilder[property] = value;
      }
    }
    return groupForBuilder;
  }

  protected formatDate(date: Date): string {
    return (date ? date.toString().split('T')[0] : '');
  }
}
