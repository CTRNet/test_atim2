<?php

class AliquotUse extends InventoryManagementAppModel {
	
	var $belongsTo = array(       
		'AliquotMaster' => array(           
			'className'    => 'Inventorymanagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'));

	public static $mValidate = null;
	
	/**
	 * Will update use_datetime and used_by fields for a list of aliquot uses.
	 *
	 * @param $aliquot_use_ids List of aliquot use ids to update.
	 * @param $use_datetime New use_datetime value
	 * @param $used_by New used_by value 
	 * 
	 * @return FALSE when error has been detected
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	 
	function updateAliquotUses($aliquot_use_ids, $use_datetime, $used_by) {
		if(((!is_array($aliquot_use_ids)) && !$aliquot_use_ids) || (!$use_datetime) || (!$used_by)) { 
			AppController::getInstance()->redirect('/pages/err_inv_funct_param_missing', null, true);
		}		
		foreach($aliquot_use_ids as $aliquot_use_id) {
			$this->id = $aliquot_use_id;
			if(!$this->save(array('AliquotUse' => array('used_by' => $used_by, 'use_datetime' => $use_datetime)))) { return false; }
		}
		return true;
	}
}

?>
