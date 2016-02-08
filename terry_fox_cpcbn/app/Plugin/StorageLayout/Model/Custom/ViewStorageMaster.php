<?php

class ViewStorageMasterCustom extends ViewStorageMaster {
	
	var $name = 'ViewStorageMaster';
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
		&& is_array($queryData['conditions'])
		&& (AppModel::isFieldUsedAsCondition("ViewStorageMaster.qc_tf_tma_label_site", $queryData['conditions'])
		|| AppModel::isFieldUsedAsCondition("ViewStorageMaster.qc_tf_tma_name", $queryData['conditions']))) {
			AppController::addWarningMsg(__('your search will be limited to your bank'));
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			$queryData['conditions'][] = array("ViewStorageMaster.qc_tf_bank_id" => $user_bank_id);
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		if(isset($results[0]['ViewStorageMaster'])) {
			//Get user and bank information
				// NOTE: Will Use data returned by StorageMaster.afterFind() function
			//Process data
			$StorageMasterModel = null;
			foreach($results as &$result) {
				//Manage confidential information and create the storage information label to display
					// NOTE: Will Use data returned by StorageMaster.afterFind() function
				$storage_master_data = null;
				if(isset($result['ViewStorageMaster']['id'])) {
					if(!isset($result['StorageMaster'])) {
						if(!$StorageMasterModel) $StorageMasterModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
						$storage_master_data = $StorageMasterModel->find('first', array('conditions' => array('StorageMaster.id' => $result['StorageMaster']['id']), 'recursive' => '-1'));
					} else {
						$storage_master_data = array('StorageMaster' => $result['StorageMaster']);
					}
				}
				if($storage_master_data) {
					if(isset($result['ViewStorageMaster']['qc_tf_bank_id'])) $result['ViewStorageMaster']['qc_tf_bank_id'] =  $storage_master_data['StorageMaster']['qc_tf_bank_id'];
					if(isset($result['ViewStorageMaster']['qc_tf_tma_label_site'])) $result['ViewStorageMaster']['qc_tf_tma_label_site'] = $storage_master_data['StorageMaster']['qc_tf_tma_label_site'];;
					if(isset($result['ViewStorageMaster']['qc_tf_tma_name'])) $result['ViewStorageMaster']['qc_tf_tma_name'] = $storage_master_data['StorageMaster']['qc_tf_tma_name'];;
					if(isset($result['ViewStorageMaster']['short_label'])) {
						$result['ViewStorageMaster']['procure_generated_label_for_display'] = $storage_master_data['StorageMaster']['procure_generated_label_for_display'];
					}
				}
			}
		} else if(isset($results['ViewStorageMaster'])){
			pr('TODO afterFind ViewStorageMaster');
			pr($results);
			exit;
		}
	
		return $results;
	}	
}

?>
