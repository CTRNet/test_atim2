<?php

class ClinicalannotationAppModel extends AppModel {
	
	function validateIcd10WhoCode($id){
		return CodingIcd10Who::validateId($id);
	}
	
	function validateIcd10CaCode($id){
		return CodingIcd10Ca::validateId($id);
	}
	
	function validateIcdo3TopoCode($id){
		return CodingIcdo3Topo::validateId($id);
	}
	
	function validateIcdo3MorphoCode($id){
		return CodingIcdo3Morpho::validateId($id);
	}
}

?>