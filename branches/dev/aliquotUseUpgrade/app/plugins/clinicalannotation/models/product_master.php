<?php
class ProductMaster extends ClinicalannotationAppModel {
	var $useTable = false;
	
	//only for summary purpose
	function summary( $variables=array() ) {
		$return = array(
			'menu' => array(null, __(isset($variables['CurrentFilter']) ? $variables['CurrentFilter'] : '', true)),
			'title' => array(null, __('tree view', true)),
		);
		return $return;
	}
}