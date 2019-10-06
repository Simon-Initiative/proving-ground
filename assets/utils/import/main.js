const fs = require('fs');
const xml2js = require('xml2js');
const glob = require("glob");

function findAllFiles(dir) {
  return new Promise((resolve, reject) => {
    glob(`${dir}/**/*.xml`, {}, function (err, files) {
      resolve(files);
    })
  });
}

function readFile(file) {
  return new Promise((resolve, reject) => {
    const parser = new xml2js.Parser();
    fs.readFile(file, function(err, data) {
      parser.parseString(data, function (err, result) {
        resolve(result);
      });
    });
  });
}

function getKey(content) {
  if (content === undefined || content === null) return null;
  const keys = Object.keys(content);
  if (keys.length !== 1) null;
  return Object.keys(content)[0];
}


function isSupportedType(content) {
  const key = getKey(content);
  return key === 'workbook_page';
}



function workbook_page(c) {

}

function process(content) {

  const key = getKey(content);

  if (key === 'workbook_page') {
    return Promise.resolve(workbook_page(content));
  }
}

function ingest(processed) {
  return Promise.resolve(true);
}

function main() {
  findAllFiles('/Users/darrensiegel/content/cloud')
  .then(files => Promise.all(files.map(f => readFile(f))))
  .then(contents => Promise.resolve(contents.map(c => isSupportedType(c))))
  .then(contents => Promise.all(contents.map(c => process(c))))
  .then(processed => ingest(processed))
  .then(result => console.log('done'));
}

main();

