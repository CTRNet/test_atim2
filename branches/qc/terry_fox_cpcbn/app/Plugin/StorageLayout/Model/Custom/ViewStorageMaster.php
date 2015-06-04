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
		if($_SESSION['Auth']['User']['group_id'] != '1') {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			if(isset($results[0]['ViewStorageMaster']['qc_tf_bank_id']) || isset($results[0]['ViewStorageMaster']['qc_tf_tma_label_site']) || isset($results[0]['ViewStorageMaster']['qc_tf_tma_name'])) {
				foreach($results as &$result){
					if((!isset($result['ViewStorageMaster']['qc_tf_bank_id'])) || empty($result['ViewStorageMaster']['qc_tf_bank_id']) || $result['ViewStorageMaster']['qc_tf_bank_id'] != $user_bank_id) {
						$result['ViewStorageMaster']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
						$result['ViewStorageMaster']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
						$result['ViewStorageMaster']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
					}
				}
			} else if(isset($results['ViewStorageMaster'])){
				pr('TODO afterFind storage');
				pr($results);
				exit;
			}
		}
	
		return $results;
	}	
}

?>
