const { Sequelize, Model, DataTypes } = require('sequelize');
module.exports = function(sequelize) {
  return sequelize.define('features', {
    feature_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    product_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    feature: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    value: {
      type: DataTypes.STRING(100),
      allowNull: false,
    }
  },{
    sequelize,
    tableName: 'features',
    timestamps: false
  });
};