<?php

class PathCollectionReview extends DataMartAppModel
{
  var $name = 'PathCollectionReview';
	var $useTable = 'path_collection_reviews';
	
	var $belongsTo = array('Collection' =>
                           array('className'  => 'Collection',
                                 'foreignKey' => 'collection_id'
                           )
                     );
	
		
	var $validate = array();
	
}

?>
