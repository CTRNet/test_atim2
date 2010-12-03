<?php

class BatchSet extends DatamartAppModel {

	var $useTable = 'datamart_batch_sets';
	
	public static $actions_array = array();
	
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
				'menu' => array(null));
			
		if(isset($variables['Param.Type_Of_List']) && empty($variables['BatchSet.id'])) {
			switch($variables['Param.Type_Of_List']) {
				case 'group':
					$return['menu'] = array('group batch sets');
					break;
				case 'user':
					$return['menu'] = array('my batch sets');
					break;
				case 'all':
					$return['menu'] = array('all batch sets');
					break;
				default:	
			}	
		}
					
		if ( isset($variables['BatchSet.id']) && (!empty($variables['BatchSet.id'])) ) {
			$batchset_data = $this->find('first', array('conditions'=>array('BatchSet.id' => $variables['BatchSet.id'])));
			if(!empty($batchset_data)) {
				$return['title'] = array(null, __('batchset information', null));
				$return['description'] = array(
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
	
	/**
	 * @param string $plugin
	 * @param string $model
	 * @param string $datamart_structure_id
	 * @return array Compatible Batch sets
	 */
	public function getCompatibleBatchSets($plugin, $model, $datamart_structure_id){
		$available_batchsets_conditions = array(
			array('OR' => array('AND' => array('BatchSet.plugin' => $plugin, 'BatchSet.model' => $model), 
					'BatchSet.datamart_structure_id' => $datamart_structure_id)),
			'OR' => array(
				'BatchSet.user_id' => $_SESSION['Auth']['User']['id'],
				array('BatchSet.group_id' => $_SESSION['Auth']['User']['group_id'], 'BatchSet.sharing_status' => 'group'),
				'BatchSet.sharing_status' => 'all')
		);
		
		return $this->find('all', array('conditions' => $available_batchsets_conditions));
	}
	

	public function setActionsDropdown($batch_set){
		$batch_set = $batch_set['BatchSet'];
		
		
		$compatible_batchset = array();
		$compatible_batchset['csv/csv/'.$batch_set['plugin'].'/'.$batch_set['model'].'/'.$batch_set['lookup_key_name'].'/'.$batch_set['structure_alias'].'/'.$batch_set['checklist_model'].'/'.$batch_set['checklist_data_key']] = __('export as CSV file (comma-separated values)', true);
		$compatible_batchset["datamart/batch_sets/add"] = __('new batchset', true);
		if($batch_set['id'] > 0){
			$compatible_batchset['datamart/batch_sets/remove/'.$batch_set['id']] = __('remove from batchset', true);
		}
		$compatibla_batchset_str = __('add to compatible batchset', true);
		$tmp_arr = array();
		$tmp_data = $this->getCompatibleBatchSets($batch_set['plugin'], $batch_set['model'], $batch_set['datamart_structure_id']);
		foreach($tmp_data as $batchset){
			if($batchset['BatchSet']['id'] != $batch_set['id']){
				$tmp_arr["datamart/batch_sets/add/".$batchset['BatchSet']['id']] = $batchset['BatchSet']['title'];
			}
		}
		if(count($tmp_arr) > 0){
			$compatible_batchset[__('add to compatible batchset', true)] = $tmp_arr;
		}
		$this->data['BatchSet']['id'] = 0;
		self::$actions_array = $compatible_batchset;
	}
	
	public function getActionsDropdown(){
		return self::$actions_array;
	}
}

?>