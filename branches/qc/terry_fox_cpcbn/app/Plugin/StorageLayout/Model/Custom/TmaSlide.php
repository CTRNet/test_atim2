<?php
class TmaSlideCustom extends TmaSlide{
	var $useTable = 'tma_slides';
	var $name = 'TmaSlide';
	
	private $section_ids_check = array(); 	//used for validations
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		if(isset($results[0]['TmaSlide'])) {
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
			$StorageMasterModel = null;
			$blocks_from_storage_master_ids = array();
			foreach($results as &$result){
				//Manage confidential information
				$block_data = null;
				if(!isset($result['Block'])) {
					if(!isset($blocks_from_storage_master_ids[$result['TmaSlide']['tma_block_storage_master_id']])) {
						if(!$StorageMasterModel) $StorageMasterModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
						$block_data = $StorageMasterModel->find('first', array('conditions' => array('StorageMaster.id' => $result['TmaSlide']['tma_block_storage_master_id'])));
						$blocks_from_storage_master_ids[$result['TmaSlide']['tma_block_storage_master_id']] = $block_data['StorageMaster'];
					}
					$result['Block'] = $blocks_from_storage_master_ids[$result['TmaSlide']['tma_block_storage_master_id']];
				}
				$set_to_confidential = ($user_bank_id != 'all' && (!isset($result['Block']['qc_tf_bank_id']) || $result['Block']['qc_tf_bank_id'] != $user_bank_id))? true : false;
				if($set_to_confidential) {
					if(isset($result['Block']['qc_tf_bank_id']))$result['Block']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
					if(isset($result['Block']['qc_tf_tma_label_site'])) $result['Block']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
					if(isset($result['Block']['qc_tf_tma_name'])) $result['Block']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
				}
				//Create the TMASLide information label to display
 				if(isset($result['TmaSlide']['barcode'])) {
 					$result['TmaSlide']['procure_generated_label_for_display'] = $result['TmaSlide']['barcode'];
 					if(isset($result['Block']['short_label'])) {
 						$result['TmaSlide']['procure_generated_label_for_display'] = $result['Block']['short_label'].' ('.$result['TmaSlide']['barcode'].')';
 						if(isset($result['Block']['qc_tf_tma_name'])) {
 							if($user_bank_id == 'all') {
 								$result['TmaSlide']['procure_generated_label_for_display'] = $result['Block']['qc_tf_tma_name'].' Sect#'.$result['TmaSlide']['qc_tf_cpcbn_section_id'].(isset($result['Block']['qc_tf_bank_id'])? ' ('.$bank_list[$result['Block']['qc_tf_bank_id']].')' : '');
 							} else if($result['Block']['qc_tf_bank_id'] == $user_bank_id) {
 								$result['TmaSlide']['procure_generated_label_for_display'] = $result['Block']['qc_tf_tma_label_site'].' Sect#'.$result['TmaSlide']['qc_tf_cpcbn_section_id'];
 							}
 						}
 					}
 				}
			}
		} else if(isset($results['TmaSlide'])){
			pr('TODO afterFind tma slide');
			pr($results);
			exit;
		}
	
		return $results;
	}
		
	function validates($options = array()){
		parent::validates($options);
	
		//Check tma slide section id (id unique per block)
		if(isset($this->data['TmaSlide']['qc_tf_cpcbn_section_id'])) {
			$qc_tf_cpcbn_section_id = $this->data['TmaSlide']['qc_tf_cpcbn_section_id'];
			$tma_block_storage_master_id = null;
			if(isset($this->data['TmaSlide']['tma_block_storage_master_id'])) {
				$tma_block_storage_master_id = $this->data['TmaSlide']['tma_block_storage_master_id'];
			} else if(isset($this->data['TmaSlide']['id'])) {
				$tmp_slide = $this->find('first', array('conditions' => array('TmaSlide.id' => $this->data['TmaSlide']['id']), 'fields' => array('TmaSlide.tma_block_storage_master_id'), 'recursive' => '-1'));
				if($tmp_slide) {
					$tma_block_storage_master_id = $tmp_slide['TmaSlide']['tma_block_storage_master_id'];
				}
			}
			if(!$tma_block_storage_master_id) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			// Check duplicated id for the same block into submited record
			if(!strlen($qc_tf_cpcbn_section_id)) {
				// Not studied
			} else if(isset($this->section_ids_check[$tma_block_storage_master_id.'-'.$qc_tf_cpcbn_section_id])) {
				$this->validationErrors['qc_tf_cpcbn_section_id'][] = str_replace('%s', $qc_tf_cpcbn_section_id, __('you can not record section id [%s] twice'));
			} else {
				$this->section_ids_check[$tma_block_storage_master_id.'-'.$qc_tf_cpcbn_section_id] = '';
			}
			
			// Check duplicated id for the same block into db
			$criteria = array('TmaSlide.tma_block_storage_master_id' => $tma_block_storage_master_id, 'TmaSlide.qc_tf_cpcbn_section_id' => $qc_tf_cpcbn_section_id);
			$slides_having_duplicated_id = $this->find('all', array('conditions' => $criteria, 'recursive' => -1));;
			if(!empty($slides_having_duplicated_id)) {
				foreach($slides_having_duplicated_id as $duplicate) {
					if((!array_key_exists('id', $this->data['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $this->data['TmaSlide']['id'])) {
						$this->validationErrors['qc_tf_cpcbn_section_id'][] = str_replace('%s', $qc_tf_cpcbn_section_id, __('the section id [%s] has already been recorded'));
					}
				}
			}
		}
		
		return empty($this->validationErrors);
	}
}