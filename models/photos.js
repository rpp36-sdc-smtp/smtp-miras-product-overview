const { Sequelize, Model, DataTypes } = require('sequelize');
module.exports = function(sequelize) {
  return sequelize.define('photos', {
    photos_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    style_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    url: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    thumbnail_url: {
      type: DataTypes.TEXT,
      allowNull: false,
    }
  },{
    sequelize,
    tableName: 'photos',
    timestamps: false
  });
};