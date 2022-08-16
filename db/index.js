const { pool } = require('../config/config.js');
const { Client } = require('pg');
const fs = require('fs');
const client = new Client(pool);

client.connect()
  .then(res => console.log('connected to product_overview database'))
  .catch(err => console.error('connection', err.stack));


// const CHUNK_SIZE = 10000000; // 10000000=10MB
// async function dataReader() {
//   const stream = fs.createReadStream(
//     "./data/features.csv",
//     { highWaterMark: CHUNK_SIZE }
//     // { start: 17, end: 256 }
//   );
//   for await (const data of stream) {
//     console.log(" ===== DATA ==== ", data.toString().split(/[\n,]+/));
//   }
// }
// dataReader();
module.exports = client;

