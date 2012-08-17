<?php

class SopMasterCustom extends SopMaster
{
	var $name = 'SopMaster';
    var $useTable = 'sop_masters';

	function getAllSopPermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('order' => 'SopMaster.title')) as $sop) {
			
			$result[$sop['SopMaster']['id']] = $sop['SopMaster']['code'].' [V#'.(empty($sop['SopMaster']['version'])? '?':$sop['SopMaster']['version']).' '.(empty($sop['SopMaster']['activated_date'])? '':$sop['SopMaster']['activated_date']).']';
		}
		
		return $result;
	}
	
}

?>