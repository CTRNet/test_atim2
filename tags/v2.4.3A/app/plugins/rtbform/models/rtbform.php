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
				'menu'			=>	array( NULL, $result['Rtbform']['frmTitle']),
				'title'			=>	array( NULL, $result['Rtbform']['frmTitle']),
				'data'			=> $result,
				'structure alias'=>'rtbforms'
			);
		}
		
		return $return;
	}
}

?>