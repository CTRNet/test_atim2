<?php

class CodingIcdo3Morpho extends CodingicdAppModel{

	protected static $singleton = null;
	
    var $name = 'CodingIcdo3Morpho';
	var $useTable = 'coding_icd_o_3_morphology';

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