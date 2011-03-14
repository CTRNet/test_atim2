<?php

class RealiquotingControl extends InventorymanagementAppModel {

	var $belongsTo = array(
		'ParentSampleToAliquotControl' => array(
			'className'   => 'Inventorymanagement.SampleToAliquotControl',
			'foreignKey'  => 'parent_sample_to_aliquot_control_id'),
		'ChildSampleToAliquotControl' => array(
			'className'   => 'Inventorymanagement.SampleToAliquotControl',
			'foreignKey'  => 'child_sample_to_aliquot_control_id'));

	/**
	 * @return An array of the form $data[parent_sample_control_id][parent_aliquot_control_id] = array(possible realiquots control id)
	 */
	function getPossiblities(){
		$realiquot_data_raw = $this->find('all', array('recursive' => 2));
		$realiquot_data = array();
		foreach($realiquot_data_raw as $data){
			$realiquot_data[$data['ParentSampleToAliquotControl']['SampleControl']['id']][$data['ParentSampleToAliquotControl']['AliquotControl']['id']][$data['ChildSampleToAliquotControl']['AliquotControl']['id']] = $data['ChildSampleToAliquotControl']['AliquotControl']['aliquot_type'];
		}
		return $realiquot_data;
	}
	
	function getAllowedChildrenCtrlId($sample_control_id, $parent_aliquot_control_id) {
		
		$criteria = array(
			'ParentSampleToAliquotControl.sample_control_id' => $sample_control_id, 
			'ParentSampleToAliquotControl.aliquot_control_id' => $parent_aliquot_control_id,
			'ParentSampleToAliquotControl.flag_active' => '1',
			'RealiquotingControl.flag_active' => '1',
			'ChildSampleToAliquotControl.sample_control_id' => $sample_control_id, 
			'ChildSampleToAliquotControl.flag_active' => '1'
		);	
		$realiquotind_control_data = $this->find('all', array('conditions' => $criteria));
		
		$allowed_children_aliquot_control_ids = array();
		foreach($realiquotind_control_data as $new_realiquoting_control) {
			$allowed_children_aliquot_control_ids[] = $new_realiquoting_control['ChildSampleToAliquotControl']['aliquot_control_id'];
		}		
		
		return $allowed_children_aliquot_control_ids;
	}

	function getLabBookCtrlId($parent_sample_ctrl_id, $parent_aliquot_ctrl_id, $child_aliquot_ctrl_id){
		$criteria = array(
			'ParentSampleToAliquotControl.sample_control_id' => $parent_sample_ctrl_id, 
			'ParentSampleToAliquotControl.aliquot_control_id' => $parent_aliquot_ctrl_id,
			'ParentSampleToAliquotControl.flag_active' => '1',
			'RealiquotingControl.flag_active' => '1',
			'ChildSampleToAliquotControl.sample_control_id' => $parent_sample_ctrl_id, 
			'ChildSampleToAliquotControl.aliquot_control_id' => $child_aliquot_ctrl_id, 
			'ChildSampleToAliquotControl.flag_active' => '1'
		);	
		$realiquoting_control_data = $this->find('first', array('conditions' => $criteria));

		return $realiquoting_control_data['RealiquotingControl']['lab_book_control_id'];
	}
}

?>