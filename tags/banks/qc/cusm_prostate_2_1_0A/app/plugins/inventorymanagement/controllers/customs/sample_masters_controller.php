<?php
	 
class SampleMastersControllerCustom extends SampleMastersController {
	
	function getTissueSourceList() {
		return array('prostate' => __('prostate', true));
	}
	
	function createSampleLabel($collection_id, $sample_data, $cusm_prostate_bank_identifier = null, $visit_label = null) {
					
		// Check parameters
	 	if(empty($collection_id) || empty($sample_data) || (!isset($sample_data['SampleMaster']))) { $this->redirect('/pages/err_inv_system_error', null, true); }

		// Get missing data
		if(is_null($cusm_prostate_bank_identifier) || is_null($visit_label)) {
			// Get Collection data
			App::import('Model', 'Inventorymanagement.ViewCollection');		
			$ViewCollection= new ViewCollection();
			
			$view_collection = $ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
			if(empty($view_collection)) { $this->redirect('/pages/err_inv_system_error', null, true); }
			
			// Get visit_label
			$visit_label = strtoupper($view_collection['ViewCollection']['qc_cusm_visit_label']);
			if(empty($visit_label)) { $visit_label = 'V0'; }
			
			// Get cusm_prostate_bank_identifier		
			$cusm_prostate_bank_identifier = $view_collection['ViewCollection']['qc_cusm_prostate_bank_identifier'];				
		}
		if(empty($cusm_prostate_bank_identifier)) { $cusm_prostate_bank_identifier = '--'; }

		// Build sample label
		$sample_label = $cusm_prostate_bank_identifier . ' ' . $visit_label;
		switch($sample_data['SampleMaster']['sample_type']) {
			case 'blood':
				if(isset($sample_data['SampleDetail']['blood_type'])) {
					switch($sample_data['SampleDetail']['blood_type']) {
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
							$sample_label .= ' -unknown';	
					}	
				} else {
					$sample_label .= ' -unknown';
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
//				$sample_label .=	' -FRZ';
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
	 
}
	
?>
