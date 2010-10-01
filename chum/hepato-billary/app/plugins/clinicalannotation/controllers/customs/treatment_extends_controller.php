<?php
	 
class TreatmentExtendsControllerCustom extends TreatmentExtendsController {
 		
	function addIcdCodeDescription($data) {
		
		if(isset($data['TreatmentExtend']['other_type_from_icd10_who'])) {
			if(!isset($this->CodingIcd10Who)) {
				App::import('Model', 'Codingicd.CodingIcd10Who');
				$this->CodingIcd10Who = new CodingIcd10Who();
			}
			$data['TreatmentExtend']['other_type_from_icd10_who'] .= " - ".$this->CodingIcd10Who->getDescription($data['TreatmentExtend']['other_type_from_icd10_who']);
		}
		
		if(isset($data[0]['TreatmentExtend']['other_type_from_icd10_who'])) {
			if(!isset($this->CodingIcd10Who)) {
				App::import('Model', 'Codingicd.CodingIcd10Who');
				$this->CodingIcd10Who = new CodingIcd10Who();
			}
			foreach($data as $key => $record) {
				$data[$key]['TreatmentExtend']['other_type_from_icd10_who'] .= " - ".$this->CodingIcd10Who->getDescription($data[$key]['TreatmentExtend']['other_type_from_icd10_who']);
			}
		}
		
		return $data;
	}
		
}
	
?>
