<?php

class SopControl extends SopAppModel
{
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['SopControl.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('SopControl.id'=>$variables['SopControl.id'])));
			
			$return = array(
				'Summary' => array(
					'sop_group' => $result['SopControl']['sop_group'],
					'type'	=>	$result['SopControl']['type'],
					'detail_tablename'	=>	$result['SopControl']['detail_tablename'],
					'detail_form_alias'	=>	$result['Sopcontrol']['detail_form_alias'],
					'extend_tablename'	=>	$result['SopControl']['extend_tablename'],
					'extend_form_alias'	=>	$result['SopControl']['extend_form_alias']
				)
			);
		}
		
		return $return;
	}
	
}

?>