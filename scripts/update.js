#!/usr/bin/env node
const fs = require("fs");
const { exit } = require("process");

const formulaTemplatePath = (name) => `templates/${name}.rb.tmpl`;
const formulaPath = (name) => `Formula/${name}.rb`;

const main = ({ formula, description, url, sha256, version }) => {
  if (!fs.existsSync(formulaTemplatePath(formula))) {
    console.error(`Error: ${formulaTemplatePath(formula)} is not exists`)
    exit(1)
  }
  const template = fs.readFileSync(formulaTemplatePath(formula)).toString()
  const replaceMap = { formula, description, url, sha256, version }
  const code = Object.entries(replaceMap).reduce((code, [key, value]) => {
    code = code.replace(regex, value)
    return code
  }, template)
  fs.writeFileSync(formulaPath(formula), code)
}

const [, , formula, description, homepage, url, sha256, version, license] =
  process.argv
main({ formula, description, homepage, url, sha256, version, license })
