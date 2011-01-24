<?php

class ReproductiveHistory extends ClinicalAnnotationAppModel
{
     function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ReproductiveHistory.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ReproductiveHistory.id'=>$variables['ReproductiveHistory.id'])));
			
			$return = array(
				'data'			=> $result,
				'structure alias'=>'reproductivehistories'
			);
		}
		
		return $return;
	}
}

?>