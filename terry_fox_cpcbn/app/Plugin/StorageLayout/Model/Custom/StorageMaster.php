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
		if(isset($children_array[$type_key]['procure_generated_label_for_display'])) {
			return $children_array[$type_key]['procure_generated_label_for_display'];
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
		
		//Manage confidential information and build a storage information label gathering many data like bank, etc for TMA
		if(isset($results[0]['StorageMaster'])) {
			//Get user and bank information
			$user_bank_id = '-1';
			if($_SESSION['Auth']['User']['group_id'] == '1') {
				$user_bank_id = 'all';
			} else {
				$GroupModel = AppModel::getInstance("", "Group", true);
				$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
				if($group_data) $user_bank_id = $group_data['Group']['bank_id'];
			}
			$BankModel = AppModel::getInstance("Administrate", "Bank", true);
			$bank_list = $BankModel->getBankPermissibleValuesForControls();
			//Process data
			foreach($results as &$result){
				//Manage confidential information
				$set_to_confidential = ($user_bank_id != 'all' && (!isset($result['StorageMaster']['qc_tf_bank_id']) || $result['StorageMaster']['qc_tf_bank_id'] != $user_bank_id))? true : false;
				if($set_to_confidential) {
					if(isset($result['StorageMaster']['qc_tf_bank_id'])) $result['StorageMaster']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
					if(isset($result['StorageMaster']['qc_tf_tma_label_site'])) $result['StorageMaster']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
					if(isset($result['StorageMaster']['qc_tf_tma_name'])) $result['StorageMaster']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
				}
				//Create the storage information label to display
				if(isset($result['StorageMaster']['short_label'])) {
					$result['StorageMaster']['procure_generated_label_for_display'] = $result['StorageMaster']['short_label'];
					if(isset($result['StorageMaster']['qc_tf_tma_name'])) {
						if($user_bank_id == 'all') {
							$result['StorageMaster']['procure_generated_label_for_display'] = $result['StorageMaster']['qc_tf_tma_name'].(isset($result['StorageMaster']['qc_tf_bank_id'])? ' ('.$bank_list[$result['StorageMaster']['qc_tf_bank_id']].')' : '');
						} else if($result['StorageMaster']['qc_tf_bank_id'] == $user_bank_id) {
							$result['StorageMaster']['procure_generated_label_for_display'] = $result['StorageMaster']['qc_tf_tma_label_site'];
						}
					}
					$result['StorageMaster']['procure_generated_selection_label_precision_for_display'] = ($result['StorageMaster']['procure_generated_label_for_display'] == $result['StorageMaster']['short_label'])? '' : '|| '.$result['StorageMaster']['procure_generated_label_for_display'];
				}
			}
		} else if(isset($results['StorageMaster'])){
			pr('TODO afterFind storage');
			pr($results);
			exit;
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