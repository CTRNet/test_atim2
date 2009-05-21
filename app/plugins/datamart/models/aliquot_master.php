<?php

class AliquotMaster extends DataMartAppModel
{
    var $name = 'AliquotMaster';
	var $useTable = 'aliquot_masters';

	var $belongsTo = array('StorageMaster' =>
		array('className'  => 'StorageMaster',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'storage_master_id'));
		
	var $validate = array();

}

?>
