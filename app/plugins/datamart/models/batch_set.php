<?php

class BatchSet extends DataMartAppModel
{
    var $name = 'BatchSet';
	var $useTable = 'datamart_batch_sets';
	
    var $hasMany = array(
						'BatchId' =>
						 array('className'   => 'BatchId',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'set_id',
                               'dependent'   => true,
                               'exclusive'   => false
                         )
	);
				  
    /*
    var $hasAndBelongsToMany = array(
		'BatchResult' => array(
				'className'  => 'FormField',
				'joinTable'  => 'datamart_batch_result_fields',
				'foreignKey' => 'set_id',
				'associationForeignKey'=> 'field_id',
				'conditions' => '',
				'order'      => 'model ASC, display_column ASC, display_order ASC, id DESC',
				'limit'      => '',
				'unique'       => FALSE,
				'finderQuery'  => '',
				'deleteQuery'=> ''
			)
		);
		*/
		
	var $validate = array();
	
}

?>