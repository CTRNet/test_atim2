<?php

class CodingIcd10Ca extends CodingicdAppModel{
	
	protected static $singleton = null;

    var $name = 'CodingIcd10Ca';
	var $useTable = 'coding_icd10_ca';

	var $validate = array();
	
	function __construct(){
		parent::__construct();
		self::$singleton = $this;
	}
	
	static function validateId($id){
		return self::$singleton->globalValidateId($id);
	}
}

?>