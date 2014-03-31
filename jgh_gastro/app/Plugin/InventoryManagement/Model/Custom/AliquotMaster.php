<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function generateDefaultAliquotBarcode($view_sample, $aliquot_control_data) {
		
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
		$default_barcode = 
			(empty($view_sample['ViewSample']['participant_identifier'])? '?' : str_replace('-','', $view_sample['ViewSample']['participant_identifier'])).'-'.
			$view_sample['ViewSample']['acquisition_label'].'-'.
			$view_sample['ViewSample']['qc_gastro_specimen_code'];
	
		switch($view_sample['ViewSample']['sample_type'].'-'.$aliquot_control_data['AliquotControl']['aliquot_type']) {
			case 'tissue-tube':
				$default_barcode .= '-V';
				break;
			case 'plasma':
				$default_barcode .= ' -PLS';
				break;
			case 'pbmc':
				$default_barcode .= ' -PBMC';
				break;
			default:

		}
		
		return strtoupper($default_barcode);
	}
	
}

?>
