<?php

class ReviewMaster extends DataMartAppModel
{
  var $name = 'ReviewMaster';
	var $useTable = 'review_masters';   
	
	var $belongsTo = array(
		'SampleMaster' => array(
			'className'  => 'SampleMaster',
			'foreignKey' => 'sample_master_id'
		),
		'PathCollectionReview' => array(
			'className'  => 'PathCollectionReview',
			'foreignKey' => 'path_collection_review_id'
		)
		
	);
	
	var $hasOne = array(
    				'ReviewDetail' =>
                        array(
                        	'className'    => 'ReviewDetail',
                            'conditions'   => '',
                            'order'        => '',
                            'dependent'    =>  true,
                            'foreignKey'   => 'review_master_id'
                        )
  );
	
	var $validate = array();
	
}

?>
