<?php

class MiscIdentifier extends ClinicalAnnotationAppModel
{
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['MiscIdentifier.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('MiscIdentifier.id'=>$variables['MiscIdentifier.id'])));
			
			$return = array(
				'Summary' => array(
					'name'	=>	array( NULL, $result['MiscIdentifier']['name']),
					'participant_id' => array( NULL, $result['MiscIdentifier']['participant_id']),
					'description'	=>	array(
						'relation'	=>	$result['MiscIdentifier']['relation'],
						'identifier_value'	=>	$result['MiscIdentifier']['identifier_value'],
						'identifier_abrv'	=>	$result['MiscIdentifier']['identifier_abrv'],
						'effective_date'	=>	$result['MiscIdentifier']['effective_date'],
						'expiry_date'		=>	$result['MiscIdentifier']['expiry_date'],
						'memo'				=>	$result['MiscIdentifier']['memo']
					)
				)
			);
		}
		
		return $return;
	}
}

?>