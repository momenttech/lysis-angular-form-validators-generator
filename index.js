var path = require('path');
var lysisUtils = require('api-lysis').utils;
var handlebars = lysisUtils.getHandlebars();

var tsValidatorsGenerator = function(parameters) {
  var templatePath = path.join(__dirname, 'templates');

  // templates
  lysisUtils.registerTemplate('resource-validator-base', path.join(templatePath, 'base-validators/ResourceValidatorsBase.ts.tpl'));
  lysisUtils.registerTemplate('resource-validator', path.join(templatePath, 'ResourceValidators.ts.tpl'));
  lysisUtils.registerTemplate('validation-matcher-base', path.join(templatePath, 'FormGroupValidationMatcherBase.ts.tpl'));
  lysisUtils.registerTemplate('validation-matcher', path.join(templatePath, 'FormGroupValidationMatcher.ts.tpl'));

  lysisUtils.registerTemplate('form-service', path.join(templatePath, 'tools/Form.service.ts.tpl'));
  lysisUtils.registerTemplate('form-class', path.join(templatePath, 'tools/Form.ts.tpl'));
  lysisUtils.registerTemplate('form-group-validators', path.join(templatePath, 'tools/FormGroupValidators.ts.tpl'));
  lysisUtils.registerTemplate('validation-types', path.join(templatePath, 'tools/ValidationTypes.ts.tpl'));

  lysisUtils.registerTemplate('index', path.join(templatePath, 'index.ts.tpl'));

  var basePath = path.join(parameters.config.basePath, (parameters.generatorConfig.dir ? parameters.generatorConfig.dir : 'form-validators'));

  lysisUtils.createDir(path.join(basePath, 'base-validators'));
  lysisUtils.createDir(path.join(basePath, 'tools'));

  if (!parameters.generatorConfig.classPath) {
    parameters.generatorConfig.classPath = '../backend-classes';
  }
  parameters.context.classPath = parameters.generatorConfig.classPath;

  // create resources files from templates
  for (var resourceName in parameters.context.resources) {
    var resource = parameters.context.resources[resourceName];
    var context = { resource: resource };
    var className = lysisUtils.toCamelCase(resource.title, 'upper');

    lysisUtils.createFile('resource-validator-base', `${basePath}/base-validators/${className}ValidatorsBase.ts`, context);
    // if extended-class target files exists, do not overwrite (except when required from config)
    if (!lysisUtils.exists(`${basePath}/${className}Validators.ts`)) {
      lysisUtils.createFile('resource-validator', `${basePath}/${className}Validators.ts`, context);
    }
  }

  lysisUtils.createFile('validation-matcher-base', `${basePath}/FormGroupValidationMatcherBase.ts`, parameters.context);
  lysisUtils.createFile('validation-matcher', `${basePath}/FormGroupValidationMatcher.ts`, parameters.context);

  lysisUtils.createFile('form-service', `${basePath}/tools/Form.service.ts`, parameters.context);
  lysisUtils.createFile('form-class', `${basePath}/tools/Form.ts`, parameters.context);
  lysisUtils.createFile('form-group-validators', `${basePath}/tools/FormGroupValidators.ts`, parameters.context);
  lysisUtils.createFile('validation-types', `${basePath}/tools/ValidationTypes.ts`, parameters.context);

  // create index file
  lysisUtils.createFile('index', `${basePath}/index.ts`, parameters.context);
};

// Get resource validators ****************************************************
handlebars.registerHelper('validators', function(property) {
  var validators = [];
  if (property.required) {
    validators.push('Validators.required');
  }
  switch (property.type.type) {
    // case 'boolean': ?
    case 'date':
    case 'dateTime':
    // case 'time': ?
    validators.push('CustomValidators.date'); break;
    case 'integer': validators.push('CustomValidators.digits'); break;
    case 'decimal': validators.push('CustomValidators.number'); break;
  }

  if (validators.length) {
    return '[' + validators.join(', ') + ']';
  }

  return 'null';
});

// Test the generator when starting `node index.js` directly
if (require.main === module) {
  lysisUtils.getGeneratorTester()
  .setUrl('http://127.0.0.1:8000')
  // .setUrl('https://demo.api-platform.com')
  .setGenerator(tsValidatorsGenerator)
  .test();
}

module.exports = tsValidatorsGenerator;
