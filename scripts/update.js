#!/usr/bin/env node
const fs = require("fs");
const { exit } = require("process");

const formulaTemplatePath = (name) => `templates/${name}.rb.tmpl`;
const formulaPath = (name) => `Formula/${name}.rb`;

const main = ({
  formula,
  description,
  homepage,
  url,
  sha256,
  version,
  license,
}) => {
  if (!fs.existsSync(formulaTemplatePath(formula))) {
    console.error(`Error: ${formulaTemplatePath(formula)} is not exists`)
    exit(1)
  }
  console.log({
    formula,
    description,
    homepage,
    url,
    sha256,
    version,
    license,
  })
  const template = fs.readFileSync(formulaTemplatePath(formula)).toString()
  const replaceMap = {
    formula,
    description,
    homepage,
    url,
    sha256,
    version,
    license,
  }
  const code = Object.entries(replaceMap).reduce((code, [key, value]) => {
    const regex = new RegExp(`{{\\s*${key}\\s* }}`, "g")
    code = code.replace(regex, value)
    return code
  }, template)
  fs.writeFileSync(formulaPath(formula), code)
}

const [, , formula, description, homepage, url, sha256, version, license] =
  process.argv
  console.log(process.argv)
  // console.log({
  //   formula,
  //   description,
  //   homepage,
  //   url,
  //   sha256,
  //   version,
  //   license,
  // })
main({ formula, description, homepage, url, sha256, version, license })
// commandline example:
/*
FORMULA="display-rotate" \
DESCRIPTION='Rotate your display easily via command-line on macOS using displayplacer.' \
HOMEPAGE='https://github.com/aromarious/display-rotate' \
URL='https://github.com/aromarious/display-rotate/releases/download/v1.0.0/display-rotate-1.0.2.tar.gz' \
SHA256='26e6597cff5eb6e98362e362b9ea0cc79c17be2d4685e6994a8b99f9fd755ae8' \
VERSION='v1.0.2' \
LICENSE='ISC' \
./scripts/update.js "$FORMULA" "$DESCRIPTION" "$HOMEPAGE" "$URL" "$SHA256" "$VERSION" "$LICENSE"
*/
