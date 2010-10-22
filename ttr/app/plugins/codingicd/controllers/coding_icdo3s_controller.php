<?php

class CodingIcdo3sController extends CodingicdAppController{

	var $uses = array("Codingicd.CodingIcdo3Topo", "Codingicd.CodingIcdo3Morpho"); 
	
	/* 
		Forms Helper appends a "tool" link to the "add" and "edit" form types
		Clicking that link reveals a DIV tag with this Action/View that should have functionality to affect the indicated form field.
	*/
	function tool($use_icd_type){
		parent::tool();
		$this->set("use_icd_type", $use_icd_type);
	}
	
	function search($use_icd_type = "topo", $is_tool = true){
		$model_to_use = $this->getIcdo3Type($use_icd_type);
		if($use_icd_type == "morpho"){
			parent::globalSearch($is_tool, $model_to_use, array("_description"));
		}else{
			parent::globalSearch($is_tool, $model_to_use);
		}
		$this->set("use_icd_type", $use_icd_type);
	}
	
	function autocomplete($use_icd_type = "topo"){
		parent::globalAutocomplete($this->getIcdo3Type($use_icd_type));
	}
	
	function getIcdo3Type($icd_type_name){
		$model_to_use = null;
		if($icd_type_name == "topo"){
			$model_to_use = $this->CodingIcdo3Topo;
		}else if($icd_type_name == "morpho"){
			$model_to_use = $this->CodingIcdo3Morpho;
		}else{
			$this->CodingIcdo3Topos->validationErrors[] = __("invalid model for icdo3 search [".$icd_type_name."]", true);
			$model_to_use = $this->CodingIcdo3Topo;
		}
		return $model_to_use;
	}
}

?>