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
		$return = array(
			'Summary' => array(
				'menu' => array('all')));
			
		if(isset($variables['Param.Type_Of_List'])) {
			switch($variables['Param.Type_Of_List']) {
				case 'group':
					$return['Summary']['menu'] = array('group');
					break;
				case 'all':
					$return['Summary']['menu'] = array('all');
					break;
				default:	
			}	
		}
				
		if ( isset($variables['BatchSet.id']) && (!empty($variables['BatchSet.id'])) ) {
			$batchset_data = $this->find('first', array('conditions'=>array('BatchSet.id' => $variables['BatchSet.id'])));
			if(!empty($batchset_data)) {
				$return['Summary']['title'] = array(null, __('batchset information', null));
				$return['Summary']['description'] = array(
					__('title', true) => $batchset_data['BatchSet']['title'],
					__('model', true) => $batchset_data['BatchSet']['model'],
					__('created', true) => $batchset_data['BatchSet']['created']);	
			}
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