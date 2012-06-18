<?php
class ProductMaster extends ClinicalAnnotationAppModel {
	var $useTable = false;
	
	//only for summary purpose
	function summary( $variables=array() ) {
		$return = array(
//			'menu' => array(null, __(isset($variables['CurrentFilter']) ? $variables['CurrentFilter'] : '')),
//			'title' => array(null, __('tree view')),
		);
		return $return;
	}
}