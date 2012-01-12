<?php

class ConsentMaster extends ClinicalAnnotationAppModel {
	var $belongsTo = array(        
		'ConsentControl' => array(            
		'className'    => 'ClinicalAnnotation.ConsentControl',            
		'foreignKey'    => 'consent_control_id'
		)    
	);
	
	var $hasMany = array(
		'ClinicalCollectionLink' => array(
			'className' => 'ClinicalAnnotation.ClinicalCollectionLink',
			'foreignKey' => 'consent_master_id'));
	
	static public $join_consent_control_on_dup = array('table' => 'consent_controls', 'alias' => 'ConsentControl', 'type' => 'LEFT', 'conditions' => array('consent_masters_dup.consent_control_id = ConsentControl.id'));
	
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

		$ccl_model = AppModel::getInstance("ClinicalAnnotation", "ClinicalCollectionLink", true);
		$returned_nbr = $ccl_model->find('count', array('conditions' => array('ClinicalCollectionLink.consent_master_id' => $consent_master_id)));
		if($returned_nbr > 0){
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_consent_linked_collection';
		}
		return $arr_allow_deletion;
	}	
	
	static function joinOnConsentDup($on_field){
		return array('table' => 'consent_masters', 'alias' => 'consent_masters_dup', 'type' => 'LEFT', 'conditions' => array($on_field.' = consent_masters_dup.id'));
	}
}

?>