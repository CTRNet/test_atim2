<?php

class MiscIdentifierCustom extends MiscIdentifier {
	var $useTable = 'misc_identifiers';
	var $name = 'MiscIdentifier';
	
	function allowDeletion( $id ) {
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');
		
		$ccl_model = AppModel::getInstance("Clinicalannotation", "ClinicalCollectionLink", true);
		$nbr_linked_collection = $ccl_model->find('count', array('conditions' => array('ClinicalCollectionLink.misc_identifier_id' => $id, 'ClinicalCollectionLink.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_frsq_number_linked_collection';
		}
	
		return $arr_allow_deletion;
	}
}

?>