<?php

class CodingIcd9txsControllerCustom extends CodingIcd9txsController{

	var $uses = array("Codingicd.CodingIcd9tx", "Codingicd.CodingIcd10Ca"); 
	/* 
		Forms Helper appends a "tool" link to the "add" and "edit" form types
		Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
	*/
	
	function tool($use_icd_type){
		parent::tool();
		$this->set("use_icd_type", $use_icd_type);
	}

	function search($use_icd_type = "icd9tx", $is_tool = true){
		parent::globalSearch($is_tool, $this->getIcd9Type($use_icd_type));
		$this->set("use_icd_type", $use_icd_type);
	}
	
	function autocomplete($use_icd_type = "icd9tx"){
		parent::globalAutocomplete($this->getIcd9txType($use_icd_type));
	}
	
	function getIcd9txType($icd_type_name){
		$model_to_use = null;
		if($icd_type_name == "icd9tx"){
			$model_to_use = $this->CodingIcd9tx;
		}else if($icd_type_name == "ca"){
			$model_to_use = $this->CodingIcd10Ca;
		}else{
			$this->CodingIcd9->validationErrors[] = __("invalid model for icd9s search [".$icd_type_name."]", true);
			$model_to_use = $this->CodingIcd10Who;
		}
		return $model_to_use;
	}
}

?>