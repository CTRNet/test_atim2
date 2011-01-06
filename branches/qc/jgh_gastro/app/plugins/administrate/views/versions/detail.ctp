<?php 
	$structure_links = array();
	$structures->build( $atim_structure, array('type' => 'detail', 'data' => $this->data[0], 'settings' => array('actions' => false)));
	
	unset($this->data[0]);
	$structures->build( $atim_structure, array('type' => 'index', 'data' => $this->data, 'settings' => array('header' => __('previous versions', true), 'pagination' => false)));
?>