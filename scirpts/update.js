#!/usr/bin/env node
const fs = require("fs");
const { exit } = require("process");

const formulaTemplatePath = (name) => `template/${name}.rb.tmpl`;
const formulaPath = (name) => `Formula/${name}.rb`;

const main = ({ formula, description, url, sha256, version }) => {
  if (!fs.existsSync(formulaTemplatePath(formula))) {
    console.error(`Error: ${formulaTemplatePath(formula)} is not exists`);
    exit(1);
  }

  const template = fs.readFileSync(formulaTemplatePath(formula)).toString();
  const code = template
    .replace(/{{\s?description\s?}}/, `"${description}"`)
    .replace("{{ url }}", `"${url}"`)
    .replace("{{ sha256 }}", `"${sha256}"`)
    .replace("{{ version }}", `"${version}"`);

  fs.writeFileSync(formulaPath(formula), code);
};

const [, , formula, description, url, sha256, version] = process.argv;
main({ formula, description, url, sha256, version });
