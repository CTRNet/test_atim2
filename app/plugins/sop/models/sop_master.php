<?php

class SopMaster extends SopAppModel
{
       function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['SopMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('SopMaster.id'=>$variables['SopMaster.id'])));
			
			$return = array(
				'Summary' => array(
					'title' => $result['SopMaster']['title'],
					'notes'	=>	$result['SopMaster']['notes'],
					'code'	=>	$result['SopMaster']['code'],
					'version' => $result['SopMaster']['version'],
					'sop_group'	=>	$result['SopMaster']['sop_group'],
					'type'	=>	$result['SopMaster']['type'],
					'status'	=> $result['SopMaster']['status'],
					'expiry_date'	=>	$result['SopMaster']['expiry_date'],
					'activated_date'	=>	$result['SopMaster']['actrivated_date'],
					'scope'	=>	$result['SopMaster']['scope'],
					'purpose'	=> $result['SopMaster']['purpose'],
					'detail_tablename'	=> $result['SopMaster']['detail_tablename'],
					'extend_tablename'	=> $result['SopMaster']['extend_tablename'],
					'extend_form_alias'=> $result['SopMaster']['extend_form_alias'],
					'form_id'	=>	$result['SopMaster']['form_id']
				)
			);
		}
		
		return $return;
	}
	

	
}

?>