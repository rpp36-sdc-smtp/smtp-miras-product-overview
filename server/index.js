const express = require('express')
const bodyParser = require('body-parser')
// const db = require('./queries')

const app = express()
const port = 3000

const db = require('../db/index.js');
// const { getAll, getOne, getStyles, getRelated } = require('./helpers.js');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.send('hello world!');
})

//ROUTES
// app.get('/products', db.getProducts);
// app.get('/products', getAll);
// app.get('/products/:product_id', getOne);
// app.get('/products/:product_id/styles', getStyles);
// app.get('/products/:product_id/related', getRelated);


app.listen(port, () => {
  console.log(`listening on port ${port}`);
});