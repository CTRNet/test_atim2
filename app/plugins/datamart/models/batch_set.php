<?php

class BatchSet extends DatamartAppModel {

	var $useTable = 'datamart_batch_sets';
	
	var $hasMany = array(
		'BatchId' =>
		 array('className'   => 'Datamart.BatchId',
                   'conditions'  => '',
                   'order'       => '',
                   'limit'       => '',
                   'foreignKey'  => 'set_id',
                   'dependent'   => true,
                   'exclusive'   => false
             )
	);
	
	function summary( $variables=array() ) {
		$return = false;
		
		// information about GROUP batch sets
		if ( isset($variables['Param.Group']) ) {
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, 'Group' ),
					'title'			=>	array( NULL, 'Batch Sets' ),
					
					'description'	=>	array(
						'filter'			=>	'Group'
					)
				)
			);
			
		} 
		
		// information about USER's batch sets
		else {
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $_SESSION['Auth']['User']['name'] ),
					'title'			=>	array( NULL, 'Batch Sets' ),
					
					'description'	=>	array(
						'filter'			=>	$_SESSION['Auth']['User']['name']
					)
				)
			);
			
		}
		
		return $return;
	}
	
	function getBatchSet($batch_set_id){
		$conditions = array(
			'BatchSet.id' => $batch_set_id,
			
			'or'	=> array(
				'BatchSet.group_id'	=> $_SESSION['Auth']['User']['group_id'],
				'BatchSet.user_id'	=> $_SESSION['Auth']['User']['id']
			)
		);
		$batch_set = $this->find( 'first', array( 'conditions'=>$conditions ) );
		return ($batch_set);
	}
	
}

?>