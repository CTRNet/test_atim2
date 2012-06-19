<?php

class CodingIcd9 extends CodingicdAppModel{

	protected static $singleton = null;
	
    var $name = 'CodingIcd9';
	var $useTable = 'coding_icd9_v2';

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