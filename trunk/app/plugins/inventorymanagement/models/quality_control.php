<?php

class QualityControl extends InventoryManagementAppModel
{
    var $name = 'QualityControl';
    
	var $useTable = 'quality_controls';

	var $belongsTo = array('SampleMaster' =>
		array('className' => 'SampleMaster',
			'conditions' => '',
			'order'      => '',
			'foreignKey' => 'sample_master_id'));
                              
	var $validate = array();

}

?>
