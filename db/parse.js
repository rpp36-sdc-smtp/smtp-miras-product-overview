const csv = require("csv-parser");
const createCsvStringifier = require("csv-writer").createObjectCsvStringifier;
const fs = require('fs');
const Transform = require("stream").Transform;

const result = [];


const csvStringifier = createCsvStringifier({
  header: [
    { id: "id", title: "id" },
    { id: "current_product_id", title: "current_product_id" },
    { id: "related_product_id", title: "related_product_id" },
  ],
});

// let readStream = fs.createReadStream("../csv/features.csv")
// fs.createReadStream("../csv/features.csv")
//     .pipe(csv1.parse({ headers: true }))
//     .on('error', error => console.error(error))
//     .on('data', row => {
//       var newRow = row.toString().replace(/['"]+/g, '')
//       result.push(newRow)
//     })
//     .on("finish", () => {
//       writeToPath("../csv/cleanerfeatures.csv")
//       console.log("finished"w);
//     });


let readStream = fs.createReadStream("../csv/related.csv");
let writeStream = fs.createWriteStream("../csv/relatednew.csv");

// let writeStream = fs.createWriteStream("../csv/cleanerfeatures.csv")

class CSVCleaner extends Transform {
  constructor(options) {
    super(options);
  }
  _transform(chunk, encoding, next) {
  for (let key in chunk) {
    //trims whitespace
    let trimKey = key.trim();
    chunk[trimKey] = chunk[key];
    if (key !== trimKey) {
      delete chunk[key];
    }
  }
  //filters out all non-number characters
  // let onlyNumbers = chunk.default_price.replace(/\D/g, "");
  // chunk.default_price = onlyNumbers;
  //uses our csvStringifier to turn our chunk into a csv string
  chunk = csvStringifier.stringifyRecords([chunk]);
  this.push(chunk);
  next();
}
}

const transformer = new CSVCleaner({ writableObjectMode: true });





//write header
writeStream.write(csvStringifier.getHeaderString());

readStream
  .pipe(csv())
  .pipe(transformer)
  .pipe(writeStream)
  .on("finish", () => {
    console.log("finished");
  });


// fs.createReadStream('../csv/product.csv').pipe(csv({}))
// .on('data', (data) => results.push(data))
// .on('end', () => {
//   console.log(results)
// })