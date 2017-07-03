<?php

class SopMasterCustom extends SopMaster
{
	var $name = 'SopMaster';
    var $useTable = 'sop_masters';

 	/**
	 * Get permissible values array gathering all existing sops developped for samples.
	 * To Develop
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  		
	function getSampleSopPermissibleValues() {
	    $result = array();
	    
	    // Build tmp array to sort according translation
	    foreach($this->find('all', array('order' => 'SopMaster.title')) as $sop) {
	        $result[$sop['SopMaster']['id']] = $sop['SopMaster']['code'].(empty($sop['SopMaster']['version'])? '' : ' - '.$sop['SopMaster']['version']);
	    }
	    
	    return $result;
	}
}

?>