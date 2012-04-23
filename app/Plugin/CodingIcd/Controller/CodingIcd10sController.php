<?php

class CodingIcd10sController extends CodingIcdAppController{

	var $uses = array("CodingIcd.CodingIcd10Who", "CodingIcd.CodingIcd10Ca"); 
	/* 
		Forms Helper appends a "tool" link to the "add" and "edit" form types
		Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
	*/
	
	function tool($use_icd_type){
		parent::tool($use_icd_type);
		$this->set("use_icd_type", $use_icd_type);
	}

	function search($use_icd_type = "who", $is_tool = true){
		parent::globalSearch($is_tool, $this->getIcd10Type($use_icd_type));
		$this->set("use_icd_type", $use_icd_type);
	}
	
	function autocomplete($use_icd_type = "who"){
		parent::globalAutocomplete($this->getIcd10Type($use_icd_type));
	}
	
	function getIcd10Type($icd_type_name){
		$model_to_use = null;
		if($icd_type_name == "who"){
			$model_to_use = $this->CodingIcd10Who;
		}else if($icd_type_name == "ca"){
			$model_to_use = $this->CodingIcd10Ca;
		}else{
			$this->CodingIcd10->validationErrors[] = __("invalid model for icd10 search [".$icd_type_name."]");
			$model_to_use = $this->CodingIcd10Who;
		}
		return $model_to_use;
	}
}

?>