<?php

class Drug extends DrugAppModel {
	
	var $name = 'Drug';
	var $useTable = 'drugs';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Drug.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Drug.id'=>$variables['Drug.id'])));
			
			$return = array(
				'menu'			=>	array( NULL, $result['Drug']['generic_name']),
				'title'			=>	array( NULL, $result['Drug']['generic_name']),
				'data'			=> $result,
				'structure alias'=>'drugs'
			);
		}
		
		return $return;
	}
	
 	/**
	 * Get permissible values array gathering all existing drugs.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
		}
		return $result;
	}
	
	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $drug_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($drug_id){
		
		$treatment_extend_model = new TreatmentExtend(false, 'txe_chemos');
		$returned_nbr = $treatment_extend_model->find('count', array('conditions' => array('TreatmentExtend.drug_id' => $drug_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one participant chemotherapy'); 
		}
		
		$protocol_extend_model = new ProtocolExtend(false, 'pe_chemos');
		$returned_nbr = $protocol_extend_model->find('count', array('conditions' => array('ProtocolExtend.drug_id' => $drug_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one chemotherapy protocol'); 
		}

		return array('allow_deletion' => true, 'msg' => '');
	}	
	
	
}

?>