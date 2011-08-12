<?php

class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			if(!isset($result['AliquotMaster']['storage_coord_y'])){
				$result['AliquotMaster']['storage_coord_y'] = "";
			}
			$return = array(
					'menu'	        	=> array(null, $result['AliquotMaster']['aliquot_label']),
					'title'		  		=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'data'				=> $result,
					'structure alias'	=> 'aliquotmasters'
			);
		}
		
		return $return;
	}
	
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
				$prefix = 'NC';
				break;	
			case 'ascite supernatant':
				$prefix = 'SASC';
				break;	
			case 'blood':
				$prefix = 'RL/Sang?';
				break;	
			case 'plasma':
				$prefix = 'P';
				break;					
			case 'serum':
				$prefix = 'SE';
				break;					
			case 'blood cell':
				$prefix = 'BC';
				break;	
			case 'peritoneal wash':
			case 'peritoneal wash cell':
			case 'peritoneal wash supernatant':
				$prefix = 'PW';
				break;	
			
			case 'tissue':	
				if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block') $prefix = 'OCT/FFPE?';	
			case 'cell culture':				
				if(empty($prefix)) $prefix = 'VC';
			case 'dna':
			case 'rna':
				if($view_sample['ViewSample']['initial_specimen_sample_type'] == 'ascite') {
					$prefix .= ' ASC';
				} else if($view_sample['ViewSample']['initial_specimen_sample_type'] == 'blood') {
					$prefix .= ' Sang';
				} else if($view_sample['ViewSample']['initial_specimen_sample_type'] == 'peritoneal wash') {
					$prefix .= ' PW';
				} else {
					//tissue
					if($view_sample['ViewSample']['initial_specimen_sample_type'] != 'tissue') AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					
					if(!isset($this->SampleMaster)) $this->SampleMaster = AppModel::atimNew('Inventorymanagement', 'SampleMaster', true);
					$tissue_detail = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $view_sample['ViewSample']['sample_master_id']), 'recursive' => '0'));
					if(empty($tissue_detail)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
					$prefix .= ' '.$tissue_detail['SampleDetail']['chuq_tissue_code'];					
				}
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
