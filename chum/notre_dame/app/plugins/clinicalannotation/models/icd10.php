<?php

class Icd10 extends AppModel {

   var $name = 'Icd10';
	var $useTable = 'coding_icd10';
	
	function permissibleValues() {
		$return = array();
		
		foreach ( $this->find('all',array('order'=>'Icd10.id ASC')) as $icd10 ) {
			$return[] = array(
				// value saved to DATABASE
				'value'	=> $icd10['Icd10']['id'],
				
				// default LABEL to display
				'default'	=> $icd10['Icd10']['id'].' - '.__($icd10['Icd10']['description'],TRUE),
				
				// more SPECIFIC label to use, based on TYPE of STRUCTURE
				'add'			=> $icd10['Icd10']['id'],
				'edit'		=> $icd10['Icd10']['id'],
				'editgrid'	=> $icd10['Icd10']['id']
			);
			// Add empty row to the start of the array in case code is not known
			array_unshift ($return, array(
				'value'	=> '',
				'default'	=> '',
				
				// more SPECIFIC label to use, based on TYPE of STRUCTURE
				'add'			=> '',
				'edit'		=> '',
				'editgrid'	=> '')
			);
		}
		
		return $return;
	}
	
}

?>