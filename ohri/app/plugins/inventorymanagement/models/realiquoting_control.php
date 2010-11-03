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
			
}

?>