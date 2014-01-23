<?php
class MiscIdentifierControlCustom extends MiscIdentifierControl{
	var $name 		= "MiscIdentifierControl";
	var $useTable 	= "misc_identifier_controls";
	
	function listProtocolFromId() {
		$conditions = array(
			'MiscIdentifierControl.flag_active' => '1',
			"MiscIdentifierControl.misc_identifier_name LIKE 'Q-CROC-%'");
		$miscidentifier_control_data = $this->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifierControl.misc_identifier_name ASC')));
		$list = array();
		foreach($miscidentifier_control_data as $new_ctrl) $list[$new_ctrl['MiscIdentifierControl']['id']] = $new_ctrl['MiscIdentifierControl']['misc_identifier_name'];
		return $list;
	}
}