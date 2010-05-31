<?php
	 
class SampleMastersControllerCustom extends SampleMastersController {
	 
	 function getSampleLabel($collection_id, $sample_master_data, $sample_detail = null) {
	 	// Check parameters
	 	if(empty($collection_id) || empty($sample_master_data)) { 
	 		$this->redirect('/pages/err_inv_no_data', null, true); 
	 	}

		// Get Collection data
		App::import('Model', 'Inventorymanagement.ViewCollection');		
		$this->ViewCollection = new ViewCollection();	
		$view_collection = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($view_collection)) { $this->redirect('/pages/err_inv_no_data', null, true); }
		
		// Get visit_label
		$visit_label = strtoupper($view_collection['ViewCollection']['qc_cusm_visit_label']);
		if(empty($visit_label)) { $visit_label = 'V0'; }
		
		// Get cusm_prostate_bank_identifier		
		$cusm_prostate_bank_identifier = $view_collection['ViewCollection']['qc_cusm_prostate_bank_identifier'];
		if(empty($cusm_prostate_bank_identifier)) { $cusm_prostate_bank_identifier = 'unknown'; }

		// Build sample label
		$sample_label = $cusm_prostate_bank_identifier . ' ' . $visit_label;
		switch($sample_master_data['sample_type']) {
			case 'blood':
				switch($sample_detail['blood_type']) {
					case 'EDTA':	
						$sample_label .=	' -EDB';					
						break;
					case 'gel CSA':	
						$sample_label .=	' -SRB';					
						break;	
					case 'paxgene':	
						$sample_label .=	' -RNB';					
						break;						
					case 'unknown':
					default:	
						$sample_label .=	' -unknown';
				}
				break;
			case 'serum':
				$sample_label .=	' -SER';
				break;
			case 'plasma':
				$sample_label .=	' -PLA';
				break;
			case 'blood cell':
				$sample_label .=	' -BFC';
				break;
			case 'urine':
			case 'centrifuged urine':
				$sample_label .=	' -URI';
				break;
			case 'centrifuged urine':
				$sample_label .=	' -URN';
				break;
			case 'tissue':
				$sample_label .=	' -FRZ';
				break;
			case 'rna':
				$sample_label .=	' -RNA';
				break;
			case 'dna':
				$sample_label .=	' -DNA';
				break;

			default:
				$this->redirect('/pages/err_inv_system_error', null, true);		
		}
 		
 		return $sample_label;
	 }
	
	function getTissueSourceList() {
		return array('prostate' => __('prostate', true));
	}
	 
}
	
?>
