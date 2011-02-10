<?php

class SampleDetailCustom extends SampleDetail {
	
	var $useTable = false;
	
	function getTissueSourcePermissibleValues() {
		$result = array();
		
		$result[] = array('value' => 'ovary', 'default' => __('ovary', true)); 
		$result[] = array('value' => 'omenteum', 'default' => __('omenteum', true)); 
		$result[] = array('value' => 'peritoneal nodule', 'default' => __('peritoneal nodule', true)); 
		
		return $result;
	}

}

?>
