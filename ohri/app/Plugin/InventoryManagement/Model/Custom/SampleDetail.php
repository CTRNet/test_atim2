<?php

class SampleDetailCustom extends SampleDetail {
	
	var $useTable = false;
	
	function getTissueSourcePermissibleValues() {
		$result = array(
			'ovary' 			=> __('ovary'), 
			'omenteum'			=> __('omenteum'),
			'peritoneal nodule'	=> __('peritoneal nodule')
		); 
		
		return $result;
	}

}

?>
