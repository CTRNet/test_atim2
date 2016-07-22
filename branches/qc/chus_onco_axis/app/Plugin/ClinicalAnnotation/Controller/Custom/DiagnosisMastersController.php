<?php
class DiagnosisMastersControllerCustom extends DiagnosisMastersController{
	
	function autocompleteChusMorphology() {
		//-- NOTE ----------------------------------------------------------
		//
		// This function is linked to function of the DiagnosisMaster model
		// called getChusMorphologyDataForDisplay().
		//
		// When you override the autocompleteChusMorphology() function, check
		// if you need to override these functions.
		//
		//------------------------------------------------------------------
		
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		
		//query the database
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		$final_conditions = array();
		foreach(array('tumour_type', 'tumour_cell_origin', 'tumour_category', 'morphology_code', 'behaviour_code', 'morphology_description') as $field) {
			$fields_conditions = array();
			foreach(explode(' ', $term) as $key_word) {
				if(strlen($key_word)) $fields_conditions[] = "$field LIKE '%".str_replace("'","''",$key_word)."%'";
			}
			if($fields_conditions) $final_conditions[] = implode(' OR ', $fields_conditions);
		}
		$final_conditions = '('.($final_conditions? implode(') OR (', $final_conditions) : 'TRUE').')';
		
		$data = $this->DiagnosisMaster->query("SELECT * FROM chus_morphology_coding WHERE $final_conditions ORDER BY morphology_code, tumour_type, tumour_cell_origin, tumour_category LIMIT 0,20");
		
		//build javascript textual array
		$result = "";
		foreach($data as $data_unit){
			$result .= '"'.$this->DiagnosisMaster->getChusMorphologyDataForDisplay($data_unit).'", ';
		}
		if(sizeof($result) > 0){
			$result = substr($result, 0, -2);
		}
		
		$this->set('result', "[".$result."]");				
	}
	
}