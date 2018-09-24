import { FormBuilder, FormGroup } from '@angular/forms';
import { CustomValidators } from 'ng2-validation';

import { AppValidators } from '../app-validators';
import { FormGroupValidators } from './FormGroupValidators';
import { ValidationTypes } from './ValidationTypes';
import { FormGroupValidationMatcher } from '../FormGroupValidationMatcher';
import { FormGroupValidationMatcherBase } from '../FormGroupValidationMatcherBase';

export class Form<T> {
  public formGroup: FormGroup;
  protected types: ValidationTypes;
  protected validationMatcher: FormGroupValidationMatcherBase;
  protected sourceItem: T;

  constructor(
    private formBuilder: FormBuilder,
    item?: T,
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

  set(item: T, validationTypes?: ValidationTypes): void {
    if (validationTypes) {
      this.types = validationTypes;
    } else {
      this.types = this.validationMatcher.get(item['_resource']);
    }
    this.sourceItem = item;
    this.formGroup = this.formBuilder.group(this.setFormGroupValues(item, new this.types.validator()));
  }

  protected getValue(value: any, validator: any): any {
    if (
      (this.hasValidator(validator, CustomValidators.date)) ||
      (this.hasValidator(validator, AppValidators.item))
    ) {
      if (!value) return null;
    }
    if (this.hasValidator(validator, AppValidators.boolean)) {
      if (value === '') return null;
    }
    return value;
  }

  get(): T {
    var emptyObject = new this.types.itemClass();
    var validator = new this.types.validator();
    var result = Object.assign(emptyObject, this.sourceItem, this.formGroup.value);
    for (let property in result) {
      if (property.indexOf('.') !== -1) {
        var splitProp = property.split('.');
        var fatherProp = splitProp[0];
        if (result[fatherProp] !== null) {
          if (Array.isArray(validator[property])) {
            result[fatherProp][splitProp[1]] = this.getValue(result[property], validator[property]);
          } else {
            result[fatherProp][splitProp[1]] = result[property];
          }
          delete result[property];
        }
      }
      if (Array.isArray(validator[property])) {
        result[property] = this.getValue(result[property], validator[property]);
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

  debugErrors() {
    if (this.formGroup.valid) {
      console.log('The form is valid');
      return;
    }
    for (let controlName in this.formGroup.controls) {
      let control = this.formGroup.controls[controlName];
      if (control.invalid && !control.touched) {
        console.log(controlName + ': valid = ' + control.valid + ', touched = ' + control.touched);
      }
    }
  }

  protected setFormGroupValues(item: T, group: FormGroupValidators): any {
    item = Object.assign({}, item);
    var groupForBuilder = {};
    for (let property in group) {
      // sometimes, constructors are kept
      if ((group[property] instanceof Function)) break;
      var itemValue = item[property];
      if (property.indexOf('.') !== -1) {
        var splitProp = property.split('.');
        // a compound property is found BUT it is not a proper embedded object - it might be an intentionnaly set property value, let's keep it
        // itemValue = undefined;
        // console.log('property', property, itemValue, item[splitProp[0]]);
        if (item[splitProp[0]]) {
          itemValue = item[splitProp[0]][splitProp[1]];
        }
        //else itemValue = null;
      }
      let value: string = '';
      if (itemValue !== undefined) {
        if (this.hasValidator(group[property], CustomValidators.date)) {
          value = this.formatDate(itemValue);
        } else {
          value = itemValue;
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
    if (typeof(date) === 'string') date = new Date(date);
    return (date ? date.toISOString().split('T')[0] : '');
  }

  protected hasValidator(validatorGroup: Array<any> | any, validator: any): boolean {
    if (!(validatorGroup instanceof Array)) validatorGroup = [validatorGroup];
    return (validatorGroup.indexOf(validator) !== -1);
  }
}
