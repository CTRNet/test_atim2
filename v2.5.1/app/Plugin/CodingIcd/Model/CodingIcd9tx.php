<?php

class CodingIcd9tx extends CodingIcdAppModel{

	protected static $singleton = null;
	
    var $name = 'CodingIcd9tx';
	var $useTable = 'coding_txicd9';

	var $validate = array();

	function __construct(){
		parent::__construct();
		self::$singleton = $this;
	}
	
	static function validateId($id){
		return self::$singleton->globalValidateId($id);
	}
	
	static function getSingleton(){
		return self::$singleton;
	}
	
}

?>