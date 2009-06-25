<?php

class TreatmentMaster extends ClinicalannotationAppModel {
	
	var $name = 'TreatmentMaster';
	var $useTable = 'tx_masters';
    var $actAs = array('MasterDetail');
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'        => array( NULL, $result['TreatmentMaster']['tx_group'] ),
					'title'		  => array( NULL, $result['TreatmentMaster']['tx_group'] ),

					'description' => array(
						'disease site'	=>	$result['TreatmentMaster']['disease_site'],
						'start date'	=>	$result['TreatmentMaster']['start_date'],
						'end date'      =>  $result['TreatmentMaster']['finish_date'],
						'summary'       =>  $result['TreatmentMaster']['summary']
					)
				)
			);
		}
		
		return $return;
	}
}

?>