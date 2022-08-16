const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const db = require('../db/queries.js')
const port = 3000

app.use(express.json())
app.get('/api/products', db.getAllProducts)
app.get('/api/products/:id/related', db.getRelated)
app.get('/api/products/:id', db.getProduct)
//combination of features
app.get('/api/products/:id/styles', db.getStyles)
//combination of photos/skus


app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`)
})