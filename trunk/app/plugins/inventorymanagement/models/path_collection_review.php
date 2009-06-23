<?php

class PathCollectionReview extends InventorymanagementAppModel {

	var $useTable = 'path_collection_reviews';
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['PathCollectionReview.id']) ) {
			$result = $this->find('first', array('conditions'=>array('PathCollectionReview.id'=>$variables['PathCollectionReview.id'])));
			$return = array(
				'Summary' => array(
					'menu' => array( NULL, $result['PathCollectionReview']['path_coll_rev_code'] ),
					'title' => array( NULL, $result['PathCollectionReview']['path_coll_rev_code'] ),
					
					'description' => array(
						'Review Code' => $result['PathCollectionReview']['path_coll_rev_code'],
						'Tumour Type' => $result['PathCollectionReview']['tumour_type'],
						'Review Status' => $result['PathCollectionReview']['review_status']))
			);		
		}
		
		return $return;
	}
}

?>
