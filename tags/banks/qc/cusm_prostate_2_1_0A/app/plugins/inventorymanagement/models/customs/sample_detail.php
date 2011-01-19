<?php

class SampleDetailCustom extends SampleDetail {
	
	var $useTable = false;
	var $name = 'SampleDetail';
		
	function getTissueSourcePermissibleValues() {
		return array(array('value' => 'prostate', 'default' => __('prostate', true)));
	}

}

?>
