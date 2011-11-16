<?php

class RealiquotingControl extends InventorymanagementAppModel {

	var $belongsTo = array(
		'ParentAliquotControl' => array(
			'className'   => 'Inventorymanagement.AliquotControl',
			'foreignKey'  => 'parent_aliquot_control_id'),
		'ChildAliquotControl' => array(
			'className'   => 'Inventorymanagement.AliquotControl',
			'foreignKey'  => 'child_aliquot_control_id'));

	/**
	 * @return An array of the form $data[parent_sample_control_id][parent_aliquot_control_id] = array(possible realiquots control id)
	 */
	function getPossiblities(){
		$realiquot_data_raw = $this->find('all', array('recursive' => 2));
		$realiquot_data = array();
		foreach($realiquot_data_raw as $data){
			$realiquot_data[$data['ParentAliquotControl']['sample_control_id']][$data['ParentAliquotControl']['id']][$data['ChildAliquotControl']['id']] = $data['ChildAliquotControl']['AliquotControl']['aliquot_type'];
		}
		return $realiquot_data;
	}
	
	function getAllowedChildrenCtrlId($sample_control_id, $parent_aliquot_control_id) {
		
		$criteria = array(
			'ParentAliquotControl.sample_control_id' => $sample_control_id, 
			'ParentAliquotControl.id' => $parent_aliquot_control_id,
			'ParentAliquotControl.flag_active' => '1',
			'RealiquotingControl.flag_active' => '1',
			'ChildAliquotControl.sample_control_id' => $sample_control_id, 
			'ChildAliquotControl.flag_active' => '1'
		);	
		$realiquotind_control_data = $this->find('all', array('conditions' => $criteria));
		
		$allowed_children_aliquot_control_ids = array();
		foreach($realiquotind_control_data as $new_realiquoting_control) {
			$allowed_children_aliquot_control_ids[] = $new_realiquoting_control['ChildAliquotControl']['id'];
		}		
		
		return $allowed_children_aliquot_control_ids;
	}

	function getLabBookCtrlId($parent_sample_ctrl_id, $parent_aliquot_ctrl_id, $child_aliquot_ctrl_id){
		$criteria = array(
			'ParentAliquotControl.sample_control_id' => $parent_sample_ctrl_id, 
			'ParentAliquotControl.id' => $parent_aliquot_ctrl_id,
			'ParentAliquotControl.flag_active' => '1',
			'RealiquotingControl.flag_active' => '1',
			'ChildAliquotControl.sample_control_id' => $parent_sample_ctrl_id, 
			'ChildAliquotControl.id' => $child_aliquot_ctrl_id, 
			'ChildAliquotControl.flag_active' => '1'
		);	
		$realiquoting_control_data = $this->find('first', array('conditions' => $criteria));

		return $realiquoting_control_data['RealiquotingControl']['lab_book_control_id'];
	}
}

?>