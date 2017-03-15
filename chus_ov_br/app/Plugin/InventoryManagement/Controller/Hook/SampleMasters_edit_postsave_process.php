<?php

if($is_specimen){
	if(!$this->SampleMaster->validateChusCollectionDates($sample_data, $this->request->data)) AppController::addWarningMsg(__('at least one specimen will have a collection date different than the new date of the collection'));

	//Launch collection to derivative aliquot storage spent time update
	$aliquot_master_ids_to_update = array();
	$aliquots_of_derivatives = $this->AliquotMaster->find('all', array('conditions' => array('SampleMaster.initial_specimen_sample_id' => $sample_master_id, 'SampleControl.sample_category' => 'derivative'), 'fields' => array('DISTINCT AliquotMaster.id'), 'recursive' => '0'));
	foreach($aliquots_of_derivatives as $new_id) {
		$aliquot_master_ids_to_update[] = $new_id['AliquotMaster']['id'];
	}
	if(!empty($aliquot_master_ids_to_update)) {
		$ViewAliquot = AppModel::getInstance('InventoryManagement', 'ViewAliquot');
		$table_query = str_replace('%%WHERE%%', 'AND AliquotMaster.id IN ('.implode(',',$aliquot_master_ids_to_update).')', $ViewAliquot::$table_query);
		$query = sprintf('REPLACE INTO %s (%s)', $ViewAliquot->table, $table_query);	
		$this->SampleMaster->tryCatchquery($query);
	}
}
