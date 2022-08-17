const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('postgres://user:1234@db:5432/product_overview')
const Pool = require('pg').Pool
const pool = new Pool({
  user: 'user',
  host: 'db',
  database: 'product_overview',
  password: '1234',
  port: 5432,
})


const skus = require('../models/skus.js')
const styles = require('../models/styles.js')
const photos = require('../models/photos.js')

var _skus = skus(sequelize);
var _photos = photos(sequelize)
var _styles = styles(sequelize);

_styles.hasMany(_skus,
  {
    foreignKey: 'style_id'
  });
_styles.hasMany(_photos,
  {
    foreignKey: 'style_id'
  });
_skus.hasOne(_skus)

const grabData = async (productID) => {
  const stylesData = await _styles.findAll({
    include: [
      { model: _photos, required: true, attributes: ['thumbnail_url', 'url'] },
      { model: _skus, required: true, attributes: ['skus_id', 'size', 'quantity'] }
    ],
    where: {
      product_id: productID
    }
  })
  var formattedData = stylesData.map((item) => {
    const data = item.dataValues
    let skusObj = {};
    for (const x of item.dataValues.skus) {
      skusObj[x.skus_id] = {
        "quantity": x.quantity,
        "size": x.size
      }
    }
    var newsku = { skus: skusObj }
    return { ...data, ...newsku }
  })
  return formattedData
}


const getProduct = (request, response) => {
  pool.query(`SELECT * FROM APIResponseRecords
    WHERE id = ${request.params.id}`, (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getAllProducts = (request, response) => {
  pool.query(`SELECT * FROM APIResponseRecords LIMIT 5`, (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getStyles = async (request, response) => {

  var result = await grabData(request.params.id)
  emptyResults = {};
  emptyResults.product_id = request.params.id
  emptyResults.results = result
  response.status(200).json(emptyResults)
}

const getRelated = (request, response) => {
  pool.query(`SELECT related_product_id FROM related WHERE product_id = ${request.params.id}`, (error, results) => {
    if (error) {
      console.error(error.message)
    } else {
      var empty = [];
      results.rows.map(data => (
        empty.push(data.related_product_id)
      ))
      response.status(200).send(empty)
    }
  })
}

module.exports = {
  getProduct,
  getStyles,
  getAllProducts,
  getRelated,
}