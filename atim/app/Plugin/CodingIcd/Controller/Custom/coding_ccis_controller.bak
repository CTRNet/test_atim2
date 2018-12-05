<?php

class CodingCcisControllerCustom extends CodingCcisController{

	var $uses = array("Codingicd.CodingCci", "Codingicd.CodingIcd10Ca"); 
	/* 
		Forms Helper appends a "tool" link to the "add" and "edit" form types
		Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
	*/
	
	function tool($use_icd_type){
		parent::tool();
		$this->set("use_icd_type", $use_icd_type);
	}

	function search($use_icd_type = "cci", $is_tool = true){
		parent::globalSearch($is_tool, $this->getCciType($use_icd_type));
		$this->set("use_icd_type", $use_icd_type);
	}
	
	function autocomplete($use_icd_type = "cci"){
		parent::globalAutocomplete($this->getCciType($use_icd_type));
	}
	
	function getCciType($icd_type_name){
		$model_to_use = null;
		if($icd_type_name == "cci"){
			$model_to_use = $this->CodingCci;
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