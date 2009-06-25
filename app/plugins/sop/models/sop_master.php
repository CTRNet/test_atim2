<?php

class SopMaster extends SopAppModel
{
	var $name = 'SopMaster';
    var $useTable = 'sop_masters';
	var $actAs = array('MasterDetail');	
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['SopMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('SopMaster.id'=>$variables['SopMaster.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['SopMaster']['title']),
					'title'			=>	array( NULL, $result['SopMaster']['title']),
					
					'description'	=>	array(
						'version' => $result['SopMaster']['version'],
						'status'   => $result['SopMaster']['status'],
						'expiry date' => $result['SopMaster']['expiry_date'],
						'notes'   =>  $result['SopMaster']['notes']
					)
				)
			);
		}
		
		return $return;
	}
	
}

?>