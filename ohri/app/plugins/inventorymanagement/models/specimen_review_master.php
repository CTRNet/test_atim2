<?php

class SpecimenReviewMaster extends InventoryManagementAppModel {
	var $belongsTo = array(        
		'SpecimenReviewControl' => array(            
			'className'    => 'Inventorymanagement.SpecimenReviewControl',            
			'foreignKey'    => 'specimen_review_control_id'));
}

?>
