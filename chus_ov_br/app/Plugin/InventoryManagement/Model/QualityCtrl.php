<?php

class QualityCtrl extends InventoryManagementAppModel {

  var $belongsTo = array('SampleMaster' =>
		array('className' => 'InventoryManagement.SampleMaster',
			'foreignKey' => 'sample_master_id'),
		'AliquotMaster' => array(
			'className'   => 'InventoryManagement.AliquotMaster',
			 	'foreignKey'  => 'aliquot_master_id')
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
}

?>
