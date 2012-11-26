<?php

class MiscIdentifierCustom extends MiscIdentifier {
	var $useTable = 'misc_identifiers';
	var $name = 'MiscIdentifier';
	
	function allowDeletion( $id ) {
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');
		
		$col_model = AppModel::getInstance("InventoryManagement", "Collection", true);
		$nbr_linked_collection = $col_model->find('count', array('conditions' => array('Collection.misc_identifier_id' => $id, 'Collection.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_frsq_number_linked_collection';
			return $arr_allow_deletion;
		}
	
		return parent::allowDeletion($id);
	}
}

?>