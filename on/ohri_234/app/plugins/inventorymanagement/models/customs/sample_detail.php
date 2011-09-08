<?php

class SampleDetailCustom extends SampleDetail {
	
	var $useTable = false;
	
	function getTissueSourcePermissibleValues() {
		$result = array(
			'ovary' 			=> __('ovary', true), 
			'omenteum'			=> __('omenteum', true),
			'peritoneal nodule'	=> __('peritoneal nodule', true)
		); 
		
		return $result;
	}

}

?>
