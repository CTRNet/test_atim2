<?php

class ReviewDetail extends DataMartAppModel
{
  var $name = 'ReviewDetail';
	var $useTable = 'rd_breastcancertypes';   
	
	var $belongsTo = array(
		'ReviewMaster' => array(
			'className'  => 'ReviewMaster',
			'foreignKey' => 'review_master_id'
		)
	);
	
	var $validate = array();
	
}

?>
