<?php

class Collection extends DataMartAppModel
{
    var $name = 'Collection';
	var $useTable = 'collections';
	
	var $hasMany = array(
					'SampleMaster' => array(
						'className'   => 'SampleMaster',
						'conditions'  => '',
						'order'       => '',
						'limit'       => '',
						'foreignKey'  => 'collection_id',
						'dependent'   => true,
						'exclusive'   => false,
						'finderSql'   => ''
					 )
				);
				
    var $hasOne = array(
    				'ClinicalCollectionLink' =>
                        array(
                        	'className'    => 'ClinicalCollectionLink',
                            'conditions'   => '',
                            'order'        => '',
                            'dependent'    =>  true,
                            'foreignKey'   => 'collection_id'
                        )
                  );
									
	var $validate = array();
	
}

?>
