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
				'menu' => array('quality control abbreviation', ' : ' . $qc_data['QualityCtrl']['run_id']),
				'title' => array(null, __('quality control abbreviation', true) . ' : ' . $qc_data['QualityCtrl']['run_id']),
	 			'data'			=> $result,
				'structure alias'=>'qualityctrls'
			);
		}	
		
		return $return;
	}			
			

}

?>
