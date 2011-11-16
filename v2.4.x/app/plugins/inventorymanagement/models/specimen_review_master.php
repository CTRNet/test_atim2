<?php

class SpecimenReviewMaster extends InventoryManagementAppModel {
	var $belongsTo = array(        
		'SpecimenReviewControl' => array(            
			'className'    => 'Inventorymanagement.SpecimenReviewControl',            
			'foreignKey'    => 'specimen_review_control_id'));
	
	function allowSpecimeReviewDeletion($specimen_review_id){
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>
