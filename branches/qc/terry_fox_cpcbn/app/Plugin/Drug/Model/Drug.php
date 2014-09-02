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
		$TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
		$joins= array(array(
			'table' => 'txe_chemos',
			'alias' => 'TreatmentExtendDetail',
			'type' => 'INNER',
			'conditions' => array('TreatmentExtendDetail.treatment_extend_master_id = TreatmentExtendMaster.id'))
		);
		$returned_nbr = $TreatmentExtendMaster->find('count', array('conditions' => array('TreatmentExtendDetail.drug_id' => $drug_id), 'joins' => $joins, 'recursive' => '1'));
		if($returned_nbr > 0) {
			return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one participant chemotherapy'); 
		}
		
		$ProtocolExtendMaster = AppModel::getInstance("Protocol", "ProtocolExtendMaster", true);
		$joins= array(array(
				'table' => 'pe_chemos',
				'alias' => 'ProtocolExtendDetail',
				'type' => 'INNER',
				'conditions' => array('ProtocolExtendDetail.protocol_extend_master_id = ProtocolExtendMaster.id'))
		);
		$returned_nbr = $ProtocolExtendMaster->find('count', array('conditions' => array('ProtocolExtendDetail.drug_id' => $drug_id), 'joins' => $joins, 'recursive' => '1'));
		if($returned_nbr > 0) {
			return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one protocol');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}	
	
	
}

?>