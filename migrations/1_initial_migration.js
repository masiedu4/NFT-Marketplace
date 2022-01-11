/**
    * @description      : 
    * @author           : Michael
    * @group            : 
    * @created          : 11/01/2022 - 15:15:51
    * 
    * MODIFICATION LOG
    * - Version         : 1.0.0
    * - Date            : 11/01/2022
    * - Author          : Michael
    * - Modification    : 
**/
const Migrations = artifacts.require("Migrations");
const Market = artifacts.require("Market");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Market);
};
