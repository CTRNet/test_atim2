<?php

class QualityCtrl extends InventoryManagementAppModel {

  var $belongsTo = array('SampleMaster' =>
		array('className' => 'Inventorymanagement.SampleMaster',
			'foreignKey' => 'sample_master_id'));

}

?>
