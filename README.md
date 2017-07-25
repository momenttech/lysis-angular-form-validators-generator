# Lysis Angular form validator generator

## Overview

This generator creates Angular validators from the backend, to ease forms creation.

## Samples

### Rest services

A validators set is created for each resource.

Example of validators set to check books, in the generated file `BookValidatorsBase.ts`:

```
export class BookValidatorsBase extends FormGroupValidators {
    id: [CustomValidators.digits];
    isbn: null;
    description: [Validators.required];
    author: [Validators.required];
    title: [Validators.required];
    publicationDate: [Validators.required, CustomValidators.date];
}
```

Built-in generators and generators from [ng2-validation](https://www.npmjs.com/package/ng2-validation).

## Basic usage

### The controller

In a controller, to get books:

```
import { Component, OnInit } from '@angular/core';

import { BooksService } from '../backend/services';
import { Book } from '../backend/classes';

@Component({
  selector: 'app-books-list',
  templateUrl: './books-list.component.html',
  styleUrls: ['./books-list.component.css']
})

export class BooksListComponent implements OnInit {
  books: Array<Book> = [];

  constructor(
    private booksService : BooksService
  ) {}

  ngOnInit() {
    this.booksService.getAll().subscribe(books => {
      this.books = this.books.concat(books);
    });
  }
}
```

### The template

...

### Extend validators

...


### Index file

The index file is the one to include in the application controller, services, ... to use services.

It should not be modified, as it is overwritten during further generations.

## Use

### Prerequisites

If it is not already done, install api-lysis globally and as dev dependency:

```
npm install api-lysis -g
npm install api-lysis --save-dev
```

### Install this generator

Install this generator:

```
npm install lysis-angular-form-validators-generator --save-dev
```

### Configuration

Configuration sample:

```
apis:
  http://localhost:8000:
    basePath: 'my-backend'
    hydraPrefix: 'hydra:'
    generators:
      lysis-angular-form-validators-generator:
        dir: 'services'
        classPath: '../classes'
```

Services files are generated in `my-backend/services`.

If `dir` is not set, the default value is `backend-services`.

`classPath` is the path to class files. By default it is set to `../backend-classes`.

### Start Lysis

...

### Add modules and services

Todo: reactive form, ng2-validation, ... form-service in app.module
