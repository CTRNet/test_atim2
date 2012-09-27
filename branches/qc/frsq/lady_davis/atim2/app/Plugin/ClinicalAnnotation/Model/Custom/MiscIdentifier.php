<?php
class MiscIdentifierCustom extends MiscIdentifier{
	var $name 		= "MiscIdentifier";
	var $useTable 	= "misc_identifiers";
	
	function validates($options = array()){
		$errors = parent::validates($options);
		if(isset($this->validationErrors['identifier_value']) && !is_array($this->validationErrors['identifier_value'])){
			$this->validationErrors['identifier_value'] = array($this->validationErrors['identifier_value']);
		}		
		$current = ($this->id)? $this->findById($this->id) : $this->data;
		if($current['MiscIdentifier']['misc_identifier_control_id'] == 11 && !preg_match("/^(MET|NEO)-[\d]+$/", $this->data['MiscIdentifier']['identifier_value'])){
			$this->validationErrors['identifier_value'][] = sprintf(__('the identifier expected format is %s'), 'MET-# '.__('or', true).' NEO-#');
			return false;
		}
		
		return $errors;
	}
	
	function allowDeletion( $id ) {
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');
	
		$col_model = AppModel::getInstance("InventoryManagement", "Collection", true);
		$nbr_linked_collection = $col_model->find('count', array('conditions' => array('Collection.misc_identifier_id' => $id, 'Collection.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_frsq_number_linked_collection';
			return $arr_allow_deletion;
		}
	
		return parent::allowDeletion($event_master_id);
	}
}