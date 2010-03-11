<?php
	 
class StorageMastersControllerCustom extends StorageMastersController {

	function createSelectionLabel($storage_data, $parent_storage_data) {
		if(!array_key_exists('short_label', $storage_data['StorageMaster'])) { $this->redirect('/pages/err_sto_system_error', null, true); }
		return ($storage_data['StorageMaster']['short_label']);
	}
	 
}
	
?>
