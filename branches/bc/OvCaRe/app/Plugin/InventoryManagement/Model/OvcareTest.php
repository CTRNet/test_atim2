<?php

class OvcareTest extends InventoryManagementAppModel {

  var $belongsTo = array('SampleMaster' =>
		array('className' => 'InventoryManagement.SampleMaster',
			'foreignKey' => 'sample_master_id'),
		'AliquotMaster' => array(
			'className'   => 'InventoryManagement.AliquotMaster',
			 	'foreignKey'  => 'aliquot_master_id')
	);
  
  var $registered_view = array(
  		'InventoryManagement.ViewAliquotUse' => array('OvcareTest.id')
  );
			
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['OvcareTest.id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.id'],
				'OvcareTest.id' => $variables['OvcareTest.id']);
				
			$ov_test_data = $this->find('first', array('conditions' => $criteria));
			
			$title = ($ov_test_data['AliquotMaster']['aliquot_label']? $ov_test_data['AliquotMaster']['aliquot_label'] : '-').' '.
				($ov_test_data['OvcareTest']['assay_id']? $ov_test_data['OvcareTest']['assay_id'] : '-'). ' ['.$ov_test_data['OvcareTest']['assay_id'].']';
			
			// Set summary	 	
	 		$return = array(
				'menu' => array('OvTst', ' : ' . $title),
				'title' => array(null, 'OvTst' . ' : ' . $title),
	 			'data' => $ov_test_data,
				'structure alias'=>'OvcareTests'
			);
		}	
		
		return $return;
	}			
	
	function allowDeletion($ovcare_test_id){
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	function generateOvTestCode() {
		$ov_test_to_update = $this->find('all', array('conditions' => array('OvcareTest.ov_test_code IS NULL'), 'fields' => array('OvcareTest.id'), 'recursive' => 1));
		foreach($ov_test_to_update as $new_ot) {
			$new_ov_test_id = $new_ot['OvcareTest']['id'];
			$ov_test_data = array('OvcareTest' => array('ov_test_code' => $new_ov_test_id));
			$this->id = $new_ov_test_id;
			$this->data = null;
			$this->addWritableField(array('ov_test_code'));
			$this->save($ov_test_data, false);			
		}		
	}
	
}

?>
