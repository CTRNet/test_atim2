<?php

class CodingIcdo3Topo extends CodingIcdAppModel{

	//---------------------------------------------------------------------------------------------------------------
	// Coding System: ICD-O-3
	// From: Stats Canada through the Manitoba Cancer Registry (CCR_Reference_Tables_2009_FinalDraft_21122009)
	// Notes: An effort is underway to verify the file authenticity.
	//---------------------------------------------------------------------------------------------------------------
	
	protected static $singleton = null;
	
    var $name = 'CodingIcdo3Topo';
	var $useTable = 'coding_icd_o_3_topography';

	var $validate = array();
	
	var $description_suffix_fields = array(
		'en' => array('en_sub_title', 'en_description'),
		'fr' => array('fr_sub_title', 'fr_sub_title'));
	
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
	
	static function getTopoSitesList(){
		$data = array();
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		foreach(self::$singleton->find('all', array('fields' => array('DISTINCT SUBSTRING(id, 1, 3) AS id, '.$lang.'_sub_title'))) as $new_id) {
			$data[$new_id['0']['id']] = $new_id['0']['id'].' - '.$new_id['CodingIcdo3Topo'][$lang.'_sub_title'];
		}
		return $data;
	}
	
}
