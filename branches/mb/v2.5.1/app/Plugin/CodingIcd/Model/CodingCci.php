<?php

class CodingCci extends CodingIcdAppModel{

	protected static $singleton = null;
	
    var $name = 'CodingCci';
	var $useTable = 'coding_cci';

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