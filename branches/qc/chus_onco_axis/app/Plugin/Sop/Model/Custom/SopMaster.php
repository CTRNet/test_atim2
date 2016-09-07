<?php

class SopMasterCustom extends SopMaster {
	var $name = 'SopMaster';
    var $useTable = 'sop_masters';
   
    function getQualityCtrlSopPermissibleValues() {
    	$result = array();
    	foreach($this->find('all', array('conditions' => array('SopControl.type' => 'quality control'), 'order' => 'SopMaster.title')) as $sop) {
    		$result[$sop['SopMaster']['id']] = $sop['SopMaster']['code'].' ['.$sop['SopMaster']['version'].']';
    	}
    	return $result;
    }
    
    function getSampleSopPermissibleValues() {
    	$result = array();
    	foreach($this->find('all', array('conditions' => array('SopControl.type' => 'sample'), 'order' => 'SopMaster.title')) as $sop) {
    		$result[$sop['SopMaster']['id']] = $sop['SopMaster']['code'].' ['.$sop['SopMaster']['version'].']';
    	}
    	return $result;
    }
    
    function getCollectionSopPermissibleValues() {
    	$result = array();
    	foreach($this->find('all', array('conditions' => array('SopControl.type' => 'collection'), 'order' => 'SopMaster.title')) as $sop) {
    		$result[$sop['SopMaster']['id']] = $sop['SopMaster']['code'].' ['.$sop['SopMaster']['version'].']';
    	}
    	return $result;
    }   
    
}

?>