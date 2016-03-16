<?php
	
	//Collection should be linked to a participant
	if(isset($final_options2)) {
		unset($final_options2['links']['bottom']['add collection']);
		if(Configure::read('procure_atim_version') == 'PROCESSING') {
			$final_options2['links']['bottom']['add']['add transferred aliquots - from csv'] = '/InventoryManagement/Collections/loadTransferredAliquotsData/1';
			$final_options2['links']['bottom']['add']['add transferred aliquots - direct'] = '/InventoryManagement/Collections/loadTransferredAliquotsData/0';
		}		
	}
	
?>
