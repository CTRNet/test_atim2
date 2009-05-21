<?php
class TmaSlide extends StoragelayoutAppModel
{
    var $name = 'TmaSlide';
	
	var $useTable = 'tma_slides';
	
	var $belongsTo 
		= array('StorageMaster' =>
			array('className'  => 'StorageMaster',
				 'conditions' => '',
				 'order'      => '',
				 'foreignKey' => 'storage_master_id'));
		
	var $validate = array();

}
?>
