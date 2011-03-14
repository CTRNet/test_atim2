<?php

class LabBookMaster extends LabBookAppModel {
	
	var $belongsTo = array(       
		'LabBookControl' => array(           
			'className'    => 'Labbook.LabBookControl',            
			'foreignKey'    => 'lab_book_control_id'        
		)    
	);
	
	function summary($variables = array()) {
		$return = false;
		
		if (isset($variables['LabBookMaster.id'])) {
			$result = $this->find('first', array('conditions' => array('LabBookMaster.id' => $variables['LabBookMaster.id'])));
			
			$return = array(
				'menu' => array(null, $result['LabBookMaster']['code']),
				'title' => array(null, $result['LabBookMaster']['code']),
				'data'				=> $result,
				'structure alias'	=> 'labbookmasters'
			);
		}
		
		return $return;
	}
	
	function getLabBookPermissibleValuesFromId($lab_book_control_id = null){
		$result = array(''=>'');
			
		$conditions = array();
		if(!is_null($lab_book_control_id)) {
			$conditions['LabBookMaster.lab_book_control_id'] = $lab_book_control_id;
		}			
		$available_books = $this->find('all', array('conditions' => $conditions, 'order' => 'LabBookMaster.created DESC'));
		foreach($available_books as $book) {
			$result[$book['LabBookMaster']['id']] = $book['LabBookMaster']['code'];
		}			
					
		return $result;
	}
	
	/**
	 * Sync data with a lab book.
	 * @param array $data The data to synchronize. Direct data and data array both supported
	 * @param array $models The models to go through
	 * @param string $lab_book_code The lab book code to synch with
	 * @param int $expected_ctrl_id If not null, will validate that the lab book code control id match the expected one.
	 */
	function syncData(array &$data, array $models, $lab_book_code, $expected_ctrl_id){
		$result = null;
		$lab_book = $this->find('first', array('conditions'=> array('LabBookMaster.code' => $lab_book_code)));
		if(empty($lab_book)){
			$result = __('invalid lab book code', true);
		}else if($expected_ctrl_id === false || empty($expected_ctrl_id)) {
			$result = __('no lab book can be applied to the current item(s)', true);
		}else if($lab_book['LabBookMaster']['lab_book_control_id'] != $expected_ctrl_id){
			$result = __('the selected lab book cannot be applied to the current item(s)', true);
		}else{
			$result = $lab_book['LabBookMaster']['id']; 
			if(!empty($data) && !empty($models)){
				$extract = null;
				if(isset($data[$models[0]])){
					$data = array($data);
					$extract = true;
				}else{
					$extract = false;
				}
				if($extract || (isset($data[0]) && isset($data[0][$models[0]]))){
					//proceed
					$fields = $this->getFields($lab_book['LabBookMaster']['lab_book_control_id']);
					foreach($data as &$unit){
						foreach($models as $model){
							foreach($fields as $field){
								if(isset($unit[$model]) && isset($unit[$model][$field])){
									$unit[$model][$field] = $lab_book['LabBookDetail'][$field];
								}
							}
						}
					}
				}else{
					//data to sync not found
					AppController::getInstance()->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true);
				}
				if($extract){
					$data = $data[0];
				}
				
			}
		}
		return $result;
	}
	
	/**
	 * @param string $code A lab book code to seek
	 * @return int the lab book id matching the code if it exists, false otherwise
	 */
	public function getIdFromCode($code){
		$lb = $this->find('list', array('fields' => array('LabBookMaster.id'), 'conditions' => array('LabBookMaster.code' => $code)));
		return empty($lb) ? false : array_pop($lb);
	}
	
	function allowLabBookDeletion($lab_book_master_id) {	
		$DerivativeDetail = AppModel::atimNew("inventorymanagement", "DerivativeDetail", true);
		$nbr_derivatives = $DerivativeDetail->find('count', array('conditions' => array('DerivativeDetail.lab_book_master_id' => $lab_book_master_id)));
		if($nbr_derivatives > 0) { 
			return array('allow_deletion' => false, 'msg' => 'deleted lab book is linked to a derivative'); 
		}		
		
		$Realiquoting = AppModel::atimNew("inventorymanagement", "Realiquoting", true);
		$nbr_realiquotings = $Realiquoting->find('count', array('conditions' => array('Realiquoting.lab_book_master_id' => $lab_book_master_id)));
		if($nbr_realiquotings > 0) { 
			return array('allow_deletion' => false, 'msg' => 'deleted lab book is linked to a realiquoted aliquot'); 
		}		
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	function getLabBookDerivativesList($lab_book_master_id) {
		$SampleMaster = AppModel::atimNew("inventorymanagement", "SampleMaster", true);
		
		$SampleMaster->unbindModel(array(
				'hasMany' => array('AliquotMaster'), 
				'hasOne' => array('SpecimenDetail'), 
				'belongsTo' => array('SampleControl')));
		$SampleMaster->bindModel(array(
			'belongsTo' => array('GeneratedParentSample' => array(
				'className' => 'Inventorymanagement.SampleMaster',
				'foreignKey' => 'parent_id'))));			
			
		return $SampleMaster->find('all', array('conditions' => array('DerivativeDetail.lab_book_master_id' => $lab_book_master_id)));
	}

	function getLabBookRealiquotingsList($lab_book_master_id) {
		$SampleMaster = AppModel::atimNew("inventorymanagement", "SampleMaster", true);
		$Realiquoting = AppModel::atimNew("inventorymanagement", "Realiquoting", true);
		
		$sample_master_ids = $Realiquoting->find('first', array(
			'conditions' => array('Realiquoting.lab_book_master_id' => $lab_book_master_id),
			'fields' => array('GROUP_CONCAT(AliquotMaster.sample_master_id) AS sample_master_ids')));
		$SampleMaster->unbindModel(array(
			'hasMany' => array('AliquotMaster'), 
			'hasOne' => array('SpecimenDetail','DerivativeDetail'), 
			'belongsTo' => array('SampleControl')));	
		$sample_master_from_ids = $SampleMaster->atim_list(array('conditions' => array('SampleMaster.id' => explode(',', $sample_master_ids[0]['sample_master_ids']))));		
		$realiquotings_list = $Realiquoting->find('all', array('conditions' => array('Realiquoting.lab_book_master_id' => $lab_book_master_id)));		
		foreach($realiquotings_list as $key => $realiquoting_data) {
			if(!isset($sample_master_from_ids[$realiquoting_data['AliquotMaster']['sample_master_id']])){
				AppController::getInstance()->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true);
			}
			$realiquotings_list[$key] = array_merge($sample_master_from_ids[$realiquoting_data['AliquotMaster']['sample_master_id']], $realiquoting_data);
		}
		
		return $realiquotings_list;
	}
	
	function synchLabbookRecords($lab_book_master_id, $lab_book_detail = null ) {
		$SampleMaster = AppModel::atimNew("inventorymanagement", "SampleMaster", true);
		$Realiquoting = AppModel::atimNew("inventorymanagement", "Realiquoting", true);
		$DerivativeDetail = AppModel::atimNew("inventorymanagement", "DerivativeDetail", true);
		
		if(empty($lab_book_detail)) {
			$lab_book = $this->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id)));
			if(empty($lab_book)) { AppController::getInstance()->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true); }		
			$lab_book_detail = $lab_book['LabBookDetail'];
		}
		
		unset($lab_book_detail['id']);
		unset($lab_book_detail['lab_book_master_id']);
		unset($lab_book_detail['created']);
		unset($lab_book_detail['created_by']);
		unset($lab_book_detail['modified']);
		unset($lab_book_detail['modified_by']);
		unset($lab_book_detail['deleted']);
		unset($lab_book_detail['deleted_date']);
    
		// 1 - Derivatives
						
		$SampleMaster->unbindModel(array(
			'hasMany' => array('AliquotMaster'), 
			'hasOne' => array('SpecimenDetail'), 
			'belongsTo' => array('Collection')));
		$derivatives_list = $SampleMaster->find('all', array('conditions' => array('DerivativeDetail.lab_book_master_id' => $lab_book_master_id, 'DerivativeDetail.sync_with_lab_book' => '1')));		
		
		foreach($derivatives_list as $sample_to_update) {
			$SampleMaster->id = $sample_to_update['SampleMaster']['id'];
			if(!$SampleMaster->save(array('SampleMaster' => $lab_book_detail, 'SampleDetail' => $lab_book_detail), false)) { 
				AppController::getInstance()->redirect('/pages/err_lab_book_system_error?line='.__LINE__, null, true); 
			}
			
			$DerivativeDetail->id = $sample_to_update['DerivativeDetail']['id'];	
			if(!$DerivativeDetail->save(array('DerivativeDetail' => $lab_book_detail), false)) { 
				AppController::getInstance()->redirect('/pages/err_lab_book_system_error?line='.__LINE__, null, true); 
			}
		}

		// 2 - Realiquoting

		$realiquotings_list = $Realiquoting->find('all', array('conditions' => array('Realiquoting.lab_book_master_id' => $lab_book_master_id, 'Realiquoting.sync_with_lab_book' => '1')));		
		foreach($realiquotings_list as $realiquoting_to_update) {
			$Realiquoting->id = $realiquoting_to_update['Realiquoting']['id'];
			if(!$Realiquoting->save(array('Realiquoting' => $lab_book_detail), false)) { 
				AppController::getInstance()->redirect('/pages/err_lab_book_system_error?line='.__LINE__, null, true); 
			}
		}
	}
}

?>
