<?php 
	
	if($_SESSION['Auth']['User']['group_id'] == '1' && array_key_exists('export as CSV file (comma-separated values)', $final_options['links']['bottom'])) {
		//Administartor: Allow export for TMA review
		$final_options['links']['bottom']['export as CSV file (comma-separated values)'] = array(
			'classical' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/".$atim_menu_variables['StorageMaster.id']."/0/1/');", 0),
			'for review (participant_identifier+aliquot_label)' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/".$atim_menu_variables['StorageMaster.id']."/0/2/');", 0),
			'for review (participant_identifier+aliquot_label+aliquot_barcode)' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/".$atim_menu_variables['StorageMaster.id']."/0/3/');", 0),
			'for review (aliquot_label+aliquot_barcode)' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/".$atim_menu_variables['StorageMaster.id']."/0/4/');", 0)
		);
	}
	
?>