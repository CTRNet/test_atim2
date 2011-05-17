<?php

class QualityCtrl extends InventoryManagementAppModel {

  var $belongsTo = array('SampleMaster' =>
		array('className' => 'Inventorymanagement.SampleMaster',
			'foreignKey' => 'sample_master_id'));
			
	var $hasMany = array(
		'QualityCtrlTestedAliquot' => array(
			'className'   => 'Inventorymanagement.QualityCtrlTestedAliquot',
			 'foreignKey'  => 'quality_ctrl_id'));			 			
			
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
				'title' => array(null, __('quality control abbreviation', true) . ' : ' . $qc_data['QualityCtrl']['run_id']),
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
		// Check no aliquot has been linked to qc
		$quality_ctrl_tested_aliquot_model = AppModel::getInstance("InventoryManagement", "QualityCtrlTestedAliquot", true);	
		$returned_nbr = $quality_ctrl_tested_aliquot_model->find('count', array('conditions' => array('QualityCtrlTestedAliquot.quality_ctrl_id' => $quality_ctrl_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'aliquot has been linked to the deleted qc'); 
		}
		
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
	 */
	function createCode($qc_id, $storage_data, $qc_data = null, $sample_data = null) {
		$qc_code = 'QC - ' . $qc_id;
		
		return $qc_code;
	}
}

?>
