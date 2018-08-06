 

# languages-creator

Project to start fastly to develop, test, cover and document your own programming languages. This project is based in 2 important projects: (PEGjs)[] and (CodeMirror)[].



## 1. Installation

Install the package globally:

~$ `npm install -g languages-creator`

## 2. Usage

### 2.1. Usage of the CLI

You can start a new project at the folder you want typing:

~$ `languages-creator:init -o my-new-language`

This example would create the folder "my-new-language" (if it is not already created), and it will start a new languages-creator project inside it.

### 2.2. Usage of the commands of the project

The exposed commands appear at `package.json` file, so we can run them with `npm run $command`.

Here is the list of them:

#### *Clean:* `npm run clean`

Cleans `tmp` and `node_modules` folders.

#### *Visit:* `npm run visit`

Opens a Chrome instance on the typical URL of the project.

#### *Serve:* `npm run serve`

Serves the editor on the typical URL of the project.

#### *Develop:* `npm run develop`

Starts listening for changes to rebuild the project automatically.

#### *Build:* `npm run build`

Generates files from current source.

#### *Docs:* `npm run docs`

Generates documentation from current source.

#### *Test:* `npm run test`

Tries to pass the unit tests.

#### *All:* `npm run all`

Runs `develop`, `visit` and `serve` commands, all at once.

## 3. Workflow

### 3.1. Editing the config file

In this section, we wil use `$config` to refer to the content from `/bin/modules/config.js`.

This file is a config file that you can edit for your convenience.

### 3.2. Runing the commands to start developing

To start developing in an automated environment (which you only have to take care of editing the source code), one runs:

~$ `npm run all`

With this, we can start editing files, and the changes will trigger the proper actions. If you have Google-Chrome browser available from command line instructions, it will be opened by the typical URL of the editor.

### 3.3. Editing the source code of the language

The files that match the glob pattern(s) from `$config.files.toListen` will be listened for changes on the commands:

~$ `npm run develop` 

Or directly:

~$ `npm run all` 

By default, the files that match the pattern `src/syntax/**/*.part.pegjs` will be listened for changes. This will trigger a `npm run build` that will generate some sources, from `$config.syntax.pathsGrammar` and `$config.syntax.pathsOutput`. The last group will be files that will contain the generated JavaScript source code of the parser, which loaded from NodeJS or browser environments, will make available at the outtest scope, a variable from which we can all the `~.parse(...)` method to parse text with our new parser. The name of the variable is defined at `$config.language.parserOptions.exportVar`. This is because this info is taken by the PEGjs parser as an option of the parser generation. The options of the PEGjs parser generator are set from here: `$config.language.parserOptions`. By default, the name will be `MyNewLanguage`, but you can change this.

### 3.4. Making test

The folder `/test/unit/expressions/*` contains a set of files. These files have a special nomenclature. If the file starts with `input.*`, it is taken by the expected input of the parser. If the file starts with `output.*`, it is taken by the expected output of the parser. When an input is found, its output (the same name, but starting with `output.*`) is searched for, and a new assertion to the test is added, expecting the output once the input is parsed. When the output of the parser is an object, the output is parsed as JSON. Otherwise, it is compared as string.







# Read this file
