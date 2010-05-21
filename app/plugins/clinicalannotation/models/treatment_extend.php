<?php

class TreatmentExtend extends ClinicalannotationAppModel {
    var $name = 'TreatmentExtend';
	var $useTable = false;
	
		/**
	 * Check if a record can be deleted.
	 * 
	 * @param $tx_extend_id Id of the studied record.
	 * @param $extend_tablename
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowTrtExtDeletion($tx_extend_id, $extend_tablename){
		return array('allow_deletion' => true, 'msg' => '');
	}	
}

?>