<?php

class Rtbform extends RtbformAppModel
{
  var $name = 'Rtbform';
  var $useTable = 'rtbforms';  
  
  function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Rtbform.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Rtbform.id'=>$variables['Rtbform.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['Rtbform']['frmTitle']),
					'title'			=>	array( NULL, $result['Rtbform']['frmTitle']),
					
					'description'	=>	array(
						'version' => $result['Rtbform']['frmVersion'],
						'status'   => $result['Rtbform']['frmStatus'],
						'category' => $result['Rtbform']['frmCategory'],
						'created'   =>  $result['Rtbform']['frmCreated']
					)
				)
			);
		}
		
		return $return;
	}
}

?>