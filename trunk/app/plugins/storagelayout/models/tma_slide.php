<?php
class TmaSlide extends StoragelayoutAppModel {
	
	var $belongsTo = array(
	'StorageMaster' =>
		array('className' => 'StorageMaster',
			'conditions' => '',
			'order' => '',
			'foreignKey' => 'storage_master_id'
		)
	);
		
}
?>
