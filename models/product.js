const { Sequelize, Model, DataTypes } = require('sequelize');
module.exports = function(sequelize) {
  return sequelize.define('product', {
    product_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    name: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    slogan: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    category: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    default_price: {
      type: DataTypes.STRING(10),
      allowNull: false,
    }
  },{
    sequelize,
    tableName: 'product',
    timestamps: false
  });
};