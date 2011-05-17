<?php

class ConsentMaster extends ClinicalannotationAppModel {
	var $belongsTo = array(        
		'ConsentControl' => array(            
		'className'    => 'Clinicalannotation.ConsentControl',            
		'foreignKey'    => 'consent_control_id'
		)    
	);
	
	var $hasMany = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'consent_master_id'));
	
	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $consent_master_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($consent_master_id){
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');

		$ccl_model = AppModel::getInstance("Clinicalannotation", "ClinicalCollectionLink", true);
		$returned_nbr = $ccl_model->find('count', array('conditions' => array('ClinicalCollectionLink.consent_master_id' => $consent_master_id)));
		if($returned_nbr > 0){
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_consent_linked_collection';
		}
		return $arr_allow_deletion;
	}	
	
	
}

?>