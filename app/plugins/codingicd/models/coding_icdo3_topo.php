<?php

class CodingIcdo3Topo extends CodingicdAppModel{

	protected static $singleton = null;
	
    var $name = 'CodingIcdo3Topo';
	var $useTable = 'coding_icd_o_3_topography';

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