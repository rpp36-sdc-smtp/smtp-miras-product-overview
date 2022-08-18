const { Sequelize, Model, DataTypes } = require('sequelize');
module.exports = function(sequelize) {
  return sequelize.define('related', {
    related_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    product_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    related_product_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },{
    sequelize,
    tableName: 'related',
    timestamps: false
  });
};