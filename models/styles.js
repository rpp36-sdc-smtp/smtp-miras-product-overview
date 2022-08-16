const {Sequelize, Model, DataTypes} = require("sequelize")
module.exports = function(sequelize) {
  return sequelize.define('styles', {
   style_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    product_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    name:{
      type: DataTypes.TEXT,
      allowNull: false,
    },
    original_price: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    "default?": {
      type: DataTypes.BOOLEAN,
      allowNull: true
    },
     sale_price:{
      type: DataTypes.INTEGER,
      allowNull: false,
    }},
{
    sequelize,
    tableName: 'styles',
    // schema: 'dbo',
    timestamps: false
  });
};