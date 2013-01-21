<?php

class QualityCtrl extends InventoryManagementAppModel {

  var $belongsTo = array('SampleMaster' =>
		array('className' => 'InventoryManagement.SampleMaster',
			'foreignKey' => 'sample_master_id'),
		'AliquotMaster' => array(
			'className'   => 'InventoryManagement.AliquotMaster',
			 	'foreignKey'  => 'aliquot_master_id')
	);
  
  var $registered_view = array(
  		'InventoryManagement.ViewAliquotUse' => array('QualityCtrl.id')
  );
			
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['QualityCtrl.id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.id'],
				'QualityCtrl.id' => $variables['QualityCtrl.id']);
				
			$qc_data = $this->find('first', array('conditions' => $criteria));
			
			// Set summary	 	
	 		$return = array(
				'menu' => array('QC', ' : ' . $qc_data['QualityCtrl']['run_id']),
				'title' => array(null, __('quality control abbreviation') . ' : ' . $qc_data['QualityCtrl']['run_id']),
	 			'data' => $qc_data,
				'structure alias'=>'qualityctrls'
			);
		}	
		
		return $return;
	}			
			
	/**
	 * Check if a quality control can be deleted.
	 * 
	 * @param $quality_ctrl_id Id of the studied quality control.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($quality_ctrl_id){
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Create code of a new quality control. 
	 * 
	 * @param $qc_id ID of the studied quality control.
	 * @param $qc_data Data of the quality control.
	 * @param $sample_data Data of the sample linked to this quality control.
	 * 
	 * @return The new code.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 * @deprecated
	 */
	function createCode($qc_id, $storage_data, $qc_data = null, $sample_data = null) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		$qc_code = 'QC - ' . $qc_id;
		
		return $qc_code;
	}
	
	function generateQcCode() {
		$qc_to_update = $this->find('all', array('conditions' => array('QualityCtrl.qc_code IS NULL'), 'fields' => array('QualityCtrl.id'), 'recursive' => 1));
		foreach($qc_to_update as $new_qc) {
			$new_qc_id = $new_qc['QualityCtrl']['id'];
			$qc_data = array('QualityCtrl' => array('qc_code' => 'QC - ' . $new_qc_id));
			$this->id = $new_qc_id;
			$this->data = null;
			$this->addWritableField(array('qc_code'));
			$this->save($qc_data, false);			
		}		
	}
	
}

?>
