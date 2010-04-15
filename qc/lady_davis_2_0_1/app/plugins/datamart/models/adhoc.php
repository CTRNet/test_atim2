<?php

class Adhoc extends DatamartAppModel {
	
	var $useTable = 'datamart_adhoc';
	
	function summary( $variables=array() ) {
		$return = false;
		
		// information about GROUP batch sets
		if ( $variables['Param.Type_Of_List']=='favourites' ) {
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, 'Your Favourites' ),
					'title'			=>	array( NULL, 'Adhoc Queries' ),
					
					'description'	=>	array(
						'filter'			=>	'Your Favourites'
					)
				)
			);
			
		} 
		
		// information about USER's batch sets
		else if ( $variables['Param.Type_Of_List']=='saved' ) {
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, 'Your Saved Searches' ),
					'title'			=>	array( NULL, 'Adhoc Queries' ),
					
					'description'	=>	array(
						'filter'			=>	'Your Saved Searches'
					)
				)
			);
			
		}
		
		return $return;
	}
	
}

?>