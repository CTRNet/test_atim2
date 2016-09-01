<?php

class CodingIcd10Who extends CodingIcdAppModel{
	
	//---------------------------------------------------------------------------------------------------------------
	// Coding System: ICD-10 (International)
	// From: Stats Canada (WHO_ICD10_Ever_Created_Codes_2009WC)
	//---------------------------------------------------------------------------------------------------------------
	
	protected static $singleton = null;
	
    var $name = 'CodingIcd10Who';
	var $useTable = 'coding_icd10_who';
	var $icd_description_table_fields = array(
		'search_format' => array('title', 'sub_title', 'description'),
		'detail_format' =>  array('description'));

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
	
	static function getSecondaryDiagnosisList() {
		$data = array();
		foreach(self::$singleton->find('all', array('conditions' => array("en_description LIKE 'Secondary malignant neoplasm%'"), 'fields' => array('id'))) as $new_id) {
			$data[$new_id['CodingIcd10Who']['id']] = $new_id['CodingIcd10Who']['id'].' - '.self::$singleton->getDescription($new_id['CodingIcd10Who']['id']);
		}
		return $data;
	}
}
