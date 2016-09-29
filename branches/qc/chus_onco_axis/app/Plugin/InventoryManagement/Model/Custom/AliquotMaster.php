<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	private $aliquot_labels = array();
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			if(!isset($result['AliquotMaster']['storage_coord_y'])){
				$result['AliquotMaster']['storage_coord_y'] = "";
			}
			$return = array(
					'menu'	        	=> array(null, __($result['AliquotControl']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'title'		  		=> array(null, __($result['AliquotControl']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'data'				=> $result,
					'structure alias'	=> 'aliquot_masters'
			);
		}
		
		return $return;
	}
	
	function regenerateAliquotBarcode() {
		$query_to_update = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
		$this->tryCatchQuery($query_to_update);
		$this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $query_to_update));
	}
	
	function validates($options = array()){
		if(isset($this->data['AliquotMaster']['aliquot_label'])){
			$this->checkDuplicatedAliquotLabel($this->data);
		}
		parent::validates($options);
	
		return empty($this->validationErrors);
	}
	
	function checkDuplicatedAliquotLabel($aliquot_data) {
			
		// check data structure
		$tmp_arr_to_check = array_values($aliquot_data);
		if((!is_array($aliquot_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['AliquotMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		$aliquot_label = $aliquot_data['AliquotMaster']['aliquot_label'];
	
		// Check duplicated aliquot_label into submited record
		if(!strlen($aliquot_label)) {
			// Not studied
		} else if(isset($this->aliquot_labels[$aliquot_label])) {
			$this->validationErrors['aliquot_label'][] = str_replace('%s', $aliquot_label, __('you can not record aliquot label [%s] twice'));
		} else {
			$this->aliquot_labels[$aliquot_label] = '';
		}
	
		// Check duplicated aliquot_label into db
		$criteria = array('AliquotMaster.aliquot_label' => $aliquot_label);
		$aliquots_having_duplicated_aliquot_label = $this->find('all', array('conditions' => array('AliquotMaster.aliquot_label' => $aliquot_label), 'recursive' => -1));;
		if(!empty($aliquots_having_duplicated_aliquot_label)) {
			foreach($aliquots_having_duplicated_aliquot_label as $duplicate) {
				if((!array_key_exists('id', $aliquot_data['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquot_data['AliquotMaster']['id'])) {
					$this->validationErrors['aliquot_label'][] = str_replace('%s', $aliquot_label, __('the aliquot label [%s] has already been recorded'));
				}
			}
		}
	}
}

?>
