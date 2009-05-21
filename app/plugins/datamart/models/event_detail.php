<?php

class EventDetail extends DataMartAppModel
{
    var $name = 'EventDetail';
	var $useTable = 'ed_generics';
	
	var $belongsTo = array(
		'ReviewMaster' => array(
			'className'  => 'ReviewMaster',
			'foreignKey' => 'review_master_id'
		)
	);
	var $validate = array();
	
}

?>
