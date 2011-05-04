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
	
	static function getInstance(){
		return self::$singleton;
	}
	
	function globalSearch($terms, $exact_search){
		return parent::globalSearch($terms, $exact_search, array("_title", "_sub_title", "_description"), true, null);
	}
}

?>