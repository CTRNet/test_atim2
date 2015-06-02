<?php
class StorageMasterCustom extends StorageMaster{
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function summary($variables = array()) {
		$return = false;
	
		if (isset($variables['StorageMaster.id'])) {
			$result = $this->find('first', array('conditions' => array('StorageMaster.id' => $variables['StorageMaster.id'])));
			$title = __($result['StorageControl']['storage_type']). ' : ' . $result['StorageMaster']['short_label'];
						
			if($_SESSION['Auth']['User']['group_id'] == '1') {
				$title = 'TMA ' . $result['StorageMaster']['qc_tf_tma_name'];
			} else {
				$GroupModel = AppModel::getInstance("", "Group", true);
				$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
				$user_bank_id = $group_data['Group']['bank_id'];
				if($result['StorageMaster']['qc_tf_bank_id'] == $user_bank_id) {
					$title = 'TMA ' . $result['StorageMaster']['qc_tf_tma_name'];
				}				
			}
			
			if($result['StorageControl']['is_tma_block'] && AppController::getInstance()->Session->read('flag_show_confidential')) {
				$title = 'TMA ' . $result['StorageMaster']['qc_tf_tma_name'];
			}
			
			
			
			$return = array(
				'menu' => array(null, ($title . ' [' . $result['StorageMaster']['code'].']')),
				'title' => array(null, ($title . ' [' . $result['StorageMaster']['code'].']')),
				'data'				=> $result,
				'structure alias'	=> 'storagemasters'
			);
		}
	
		return $return;
	}
	
	function getLabel(array $children_array, $type_key, $label_key) {
		if(($type_key == 'AliquotMaster')) {
			$ViewAliquotModel = AppModel::getInstance('InventoryManagement', 'ViewAliquot', true);
			$aliquot_data = $ViewAliquotModel->find('first', array('conditions' => array('ViewAliquot.aliquot_master_id' => $children_array['AliquotMaster']['id']), 'recursive' => '-1'));
			return $aliquot_data['ViewAliquot']['aliquot_label'].' ['.$aliquot_data['ViewAliquot']['barcode'].']';
		}
		return $children_array[$type_key][$label_key];
	}
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
		&& is_array($queryData['conditions'])
		&& (AppModel::isFieldUsedAsCondition("StorageMaster.qc_tf_tma_label_site", $queryData['conditions'])
		|| AppModel::isFieldUsedAsCondition("StorageMaster.qc_tf_tma_name", $queryData['conditions']))) {
			AppController::addWarningMsg(__('your search will be limited to your bank'));
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			$queryData['conditions'][] = array("StorageMaster.qc_tf_bank_id" => $user_bank_id);
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		if($_SESSION['Auth']['User']['group_id'] != '1') {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			if(isset($results[0]['StorageMaster']['qc_tf_bank_id']) || isset($results[0]['StorageMaster']['qc_tf_tma_label_site']) || isset($results[0]['StorageMaster']['qc_tf_tma_name'])) {
				foreach($results as &$result){
					if((!isset($result['StorageMaster']['qc_tf_bank_id'])) || empty($result['StorageMaster']['qc_tf_bank_id']) || $result['StorageMaster']['qc_tf_bank_id'] != $user_bank_id) {
						$result['StorageMaster']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
						$result['StorageMaster']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
						$result['StorageMaster']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
					}
				}
			} else if(isset($results['StorageMaster'])){
				pr('TODO afterFind storage');
				pr($results);
				exit;
			}
		}
	
		return $results;
	}
	
	function validates($options = array()) {
		$validate_res = parent::validates($options);
		if(array_key_exists('qc_tf_tma_label_site', $this->data['StorageMaster'])) {
			if(strlen($this->data['StorageMaster']['qc_tf_tma_label_site']) && !$this->data['StorageMaster']['qc_tf_bank_id']) {
				$this->validationErrors['qc_tf_bank_id'][] = __('a bank has to be selected');
				$validate_res =  false;
			}
		}
		return $validate_res;
	}
	
}