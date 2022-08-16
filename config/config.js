const { Pool } = require('pg')

const pool = new Pool({
  user: 'mirasadilov',
  host: 'localhost',
  database: 'product_overview',
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
  port: 5432,
})

// const getProducts = (request, response) => {
//   console.log('getting all products..');
//   pool.query("SELECT * FROM products WHERE product_id > 0 AND product_id < 6", (error, results) => {
//     if (error) {
//       console.log(error);
//     }
//     console.log(results.rows);
//     response.status(200).json(results.rows);
//   })
// }
module.exports = pool;