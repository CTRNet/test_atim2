<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';
	
	public function regenerateAliquotBarcode() {
		$query = "UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE '' OR barcode IS NULL";
		$this->tryCatchQuery($query);
		$this->tryCatchQuery(str_replace('aliquot_masters', 'aliquot_masters_revs', $query));
		//The Barcode values of AliquotView will be updated by AppModel::releaseBatchViewsUpdateLock(); call in AliquotMaster.add() and AliquotMaster.realiquot() function
	}

	public function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		if(isset($results[0]['AliquotMaster'])) {
			$ViewAliquotModel = null;
			foreach($results as &$result) {
				//Manage confidential information and create the aliquot information label to display: Will Use data returned by ViewAliquot.afterFind() function
				if(array_key_exists('aliquot_label', $result['AliquotMaster'])) {
					$aliquotViewData = null;
					if(!isset($result['ViewAliquot'])) {
						if(!$ViewAliquotModel) $ViewAliquotModel = AppModel::getInstance("InventoryManagement", "ViewAliquot", true);
						$aliquotViewData = $ViewAliquotModel->find('first', array('conditions' => array('ViewAliquot.aliquot_master_id' => $result['AliquotMaster']['id']), 'recursive' => -1));
					} else {
						$aliquotViewData = array('ViewAliquot' => $result['ViewAliquot']);
					}
					if(isset($result['AliquotMaster']['aliquot_label'])) {
						$result['AliquotMaster']['aliquot_label'] = isset($aliquotViewData['ViewAliquot']['aliquot_label'])? $aliquotViewData['ViewAliquot']['aliquot_label'] : CONFIDENTIAL_MARKER;
					}
					if(isset($aliquotViewData['ViewAliquot']['qbcf_generated_label_for_display'])) {
						$result['AliquotMaster']['qbcf_generated_label_for_display'] = isset($aliquotViewData['ViewAliquot']['qbcf_generated_label_for_display'])? $aliquotViewData['ViewAliquot']['qbcf_generated_label_for_display'] : CONFIDENTIAL_MARKER;
					}
				}
			}
		} elseif(isset($results['AliquotMaster'])){
			pr('TODO afterFind AliquotMaster');
			pr($results);
			exit;
		}
		
		return $results;
	}
	
	public function updateAliquotLabel($collectionIds, $acquireBatchViewsUpdateLock = false) {	
		if(!is_array($collectionIds)) $collectionIds = array($collectionIds);
		if($collectionIds) {
			$collectionIds = implode(',', $collectionIds);
			if($collectionIds) {
				$query = "SELECT
					AliquotMaster.id AS aliquot_master_id,
					AliquotMaster.sample_master_id AS sample_master_id,
					SampleControl.sample_type,
					SampleMaster.qbcf_tma_sample_control_code,
					AliquotControl.aliquot_type,
					Collection.qbcf_pathology_id,
					Collection.collection_property,
					AliquotMaster.aliquot_label,
					BlockAliquotDetail.patho_dpt_block_code,
					ParentBlockAliquotDetail.patho_dpt_block_code,
					CoreAliquotDetail.qbcf_core_nature_site,
					CoreAliquotDetail.qbcf_core_nature_revised
					FROM aliquot_masters AS AliquotMaster
					INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
					INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
					INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
					INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
					LEFT JOIN ad_blocks AS BlockAliquotDetail ON BlockAliquotDetail.aliquot_master_id = AliquotMaster.id
					LEFT JOIN ad_tissue_cores AS CoreAliquotDetail ON CoreAliquotDetail.aliquot_master_id = AliquotMaster.id
					LEFT JOIN realiquotings Realiquoting ON Realiquoting.child_aliquot_master_id = AliquotMaster.id AND Realiquoting.deleted != 1
					LEFT JOIN aliquot_masters ParentAliquotMaster ON Realiquoting.parent_aliquot_master_id = ParentAliquotMaster.id AND ParentAliquotMaster.deleted != 1
					LEFT JOIN ad_blocks AS ParentBlockAliquotDetail ON ParentBlockAliquotDetail.aliquot_master_id = ParentAliquotMaster.id
					WHERE SampleControl.sample_type = 'tissue'
					AND AliquotMaster.deleted != 1 
					AND AliquotMaster.collection_id IN ($collectionIds) 
					AND AliquotControl.aliquot_type IN ('slide','core','block');";
				
				if($acquireBatchViewsUpdateLock) AppModel::acquireBatchViewsUpdateLock();
				
				$this->addWritableField(array('aliquot_label'));
				foreach($this->tryCatchQuery($query) as $newAliquot) {
					$newAliquotLabel = '';
					$suffix = '';
					if($newAliquot['Collection']['collection_property'] == 'participant collection') {
						switch($newAliquot['AliquotControl']['aliquot_type']) {
							case 'block':
								$newAliquotLabel = $newAliquot['Collection']['qbcf_pathology_id'].' '.$newAliquot['BlockAliquotDetail']['patho_dpt_block_code'];
								break;
							case 'core':
								$suffix = strlen($newAliquot['CoreAliquotDetail']['qbcf_core_nature_revised'])? 
									$newAliquot['CoreAliquotDetail']['qbcf_core_nature_revised'] : 
									(strlen($newAliquot['CoreAliquotDetail']['qbcf_core_nature_site'])? $newAliquot['CoreAliquotDetail']['qbcf_core_nature_site'] : 'U');
								if(strlen($suffix)) {
									$suffix = ' -'.substr(strtoupper($suffix), 0, 1);
								} else {
									$suffix = ' -?';
								}
							case 'slide':
								$newAliquotLabel = $newAliquot['Collection']['qbcf_pathology_id'].' '.(strlen($newAliquot['ParentBlockAliquotDetail']['patho_dpt_block_code'])? $newAliquot['ParentBlockAliquotDetail']['patho_dpt_block_code'] : '?');
								break;
									
							default:
								AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
						}
					} else {
						//Control
						$newAliquotLabel = $newAliquotLabel = $newAliquot['SampleMaster']['qbcf_tma_sample_control_code'];
					}
					$newAliquotLabel = $newAliquotLabel.$suffix;					
					if($newAliquot['AliquotMaster']['aliquot_label'] != $newAliquotLabel) {					
						$this->data = array();
						$this->id = $newAliquot['AliquotMaster']['aliquot_master_id'];
						if(!$this->save(array('AliquotMaster' => array('aliquot_label' => $newAliquotLabel)))) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
					}
				}
				
				if($acquireBatchViewsUpdateLock) AppModel::releaseBatchViewsUpdateLock();
			}
		}
	}
}