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
	
	function synchData($submitted_data, $model, $lab_book_fields_to_synch) {
		$errors = array();

		if(array_key_exists($model,$submitted_data) 
		&& array_key_exists('sync_with_lab_book',$submitted_data[$model]) 
		&& $submitted_data[$model]['sync_with_lab_book']) {
			if(!array_key_exists('lab_book_master_id',$submitted_data[$model])) {
				AppController::getInstance()->redirect('/pages/err_lab_book_system_error?line='.__LINE__, null, true);
			} else if(empty($submitted_data[$model]['lab_book_master_id'])) {
				$errors[] = 'a lab book should be selected to synchronize';
			} else {
				$lab_book = $this->find('first', array('conditions'=> array('LabBookMaster.id' => $submitted_data[$model]['lab_book_master_id'])));
				if(empty($lab_book)) { AppController::getInstance()->redirect('/pages/err_lab_book_system_error?line='.__LINE__, null, true); }
				foreach($submitted_data as $sub_data_model => $model_values) {
					foreach($model_values as $field => $value) {
						if(in_array($field, $lab_book_fields_to_synch)) {
							$submitted_data[$sub_data_model][$field] = $lab_book['LabBookDetail'][$field];
						}
					}
				}
			}
		}
		
		return array('errors'=> $errors, 'synchronized_data'=>$submitted_data);
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
		if($nbr_derivatives > 0) { return array('allow_deletion' => false, 'msg' => 'deleted lab book is linked to a derivative'); }		
		
		$Realiquoting = AppModel::atimNew("inventorymanagement", "Realiquoting", true);
		$nbr_realiquotings = $Realiquoting->find('count', array('conditions' => array('Realiquoting.lab_book_master_id' => $lab_book_master_id)));
		if($nbr_realiquotings > 0) { return array('allow_deletion' => false, 'msg' => 'deleted lab book is linked to a realiquoted aliquot'); }		
		
		return array('allow_deletion' => true, 'msg' => '');
	}

}

?>
