<?php

class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {

		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
		$participant_ns = empty($view_sample['ViewSample']['participant_identifier'])?'n/a' : $view_sample['ViewSample']['participant_identifier'];
		$collection_date = 	empty($view_sample['ViewSample']['collection_datetime'])?'n/a' : substr($view_sample['ViewSample']['collection_datetime'],0,10);

		$prefix = '';
		switch($view_sample['ViewSample']['sample_type']) {
			case 'ascite':
				$prefix = 'ASC';
				break;
			case 'ascite cell':
				$prefix = 'ASC NC';
				break;	
			case 'ascite supernatant':
				$prefix = 'SASC';
				break;	
	
			case 'blood':
				$prefix = '?';	//C
				break;	
			case 'plasma':
				$prefix = 'P';
				break;					
			case 'serum':
				$prefix = 'SE';
				break;					
			case 'pbmc':
				$prefix = 'C';
				break;	
			case 'peritoneal wash':
			case 'peritoneal wash cell ':
			case 'peritoneal wash supernatant':
				$prefix = '?';
				break;	
				
			case 'tissue':	
				if(!isset($this->SampleMaster)) $this->SampleMaster = AppModel::atimNew('Inventorymanagement', 'SampleMaster', true);
				$tissue_detail = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $view_sample['ViewSample']['sample_master_id']), 'recursive' => '0'));
				if(empty($tissue_detail)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				$prefix = $tissue_detail['SampleDetail']['chuq_tissue_code'];
				break;
				
			case 'cell culture ':
			case 'dna':
			case 'rna':
				if(!isset($this->SampleMaster)) $this->SampleMaster = AppModel::atimNew('Clinicalannotation', 'SampleMaster', true);
				$tissue_detail = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $view_sample['ViewSample']['initial_specimen_sample_id']), 'recursive' => '0'));
				if(empty($tissue_detail)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				$prefix = $tissue_detail['SampleDetail']['chuq_tissue_code'];				
				break;
			default:
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}

		return $prefix.' '.$participant_ns.' '.$collection_date;
	}
	
	function regenerateAliquotBarcode() {
		$this->unbindModel(array(
		'hasOne' => array('SpecimenDetail'),
		'belongsTo' => array('Collection','StorageMaster')));
		$aliquots_to_update = $this->find('all', array('conditions' => array('AliquotMaster.barcode' => '')));
		foreach($aliquots_to_update as $new_aliquot) {
			$this->data = array();
			$this->id = $new_aliquot['AliquotMaster']['id'];
			$barcode = 'tmp_'.str_replace(" ", "", $new_aliquot['SampleMaster']['sample_code']).'_'.$new_aliquot['AliquotMaster']['id'];
			if(!$this->save(array('AliquotMaster' => array('barcode' => $barcode)), false)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}	
	}
	
}

?>
