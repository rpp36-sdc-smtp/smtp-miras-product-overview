const {Sequelize, Model, DataTypes} = require("sequelize")
module.exports = function(sequelize) {
  return sequelize.define('skus', {
   skus_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    style_id:{
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    size: {
      type: DataTypes.STRING(15),
      allowNull: true
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: true
    }},
{
    sequelize,
    tableName: 'skus',
    // schema: 'dbo',
    timestamps: false
  });
};