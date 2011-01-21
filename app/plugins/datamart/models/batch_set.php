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
		$return = array('menu' => array(null));
					
		if(isset($variables['Param.Type_Of_List']) && empty($variables['BatchSet.id'])) {
			switch($variables['Param.Type_Of_List']) {
				case 'group':
					$return['menu'] = array(__('group batch sets',true));
					break;
				case 'user':
					$return['menu'] = array(__('my batch sets',true));
					break;
				case 'all':
					$return['menu'] = array(__('all batch sets',true));
					break;
				default:	
			}	
		}
					
		if ( isset($variables['BatchSet.id']) && (!empty($variables['BatchSet.id'])) ) {
			$batchset_data = $this->find('first', array('conditions'=>array('BatchSet.id' => $variables['BatchSet.id'])));
			if(!empty($batchset_data)) {
				$return['title'] = array(null, __('batchset information', null));
				$return['menu'] = array(null, $batchset_data['BatchSet']['title']);
				$return['structure alias'] = 'querytool_batch_set';
				$return['data'] = $batchset_data;
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
	
	/**
	 * @desc Verifies if a user can read/write a batchset. If it fails, the browser 
	 * will be redirected to a flash screen.
	 * @param array $batchset The batchset data
	 * @param boolean $must_be_unlocked If true, the batchset must be unlocked to authorize access.
	 */
	public function isUserAuthorizedToRw(array $batchset, $must_be_unlocked){
		if(empty($batchset) 
		|| (!(array_key_exists('user_id', $batchset['BatchSet'])
		&& array_key_exists('group_id', $batchset['BatchSet'])
		&& array_key_exists('sharing_status', $batchset['BatchSet'])))) {
			AppController::getInstance()->redirect('/pages/err_datamart_system_error', null, true);
		}
		
		$allowed = null;
		switch($batchset['BatchSet']['sharing_status']){
			case 'user' :
				$allowed = $batchset['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id'];
				break;
			case 'group' :
				$allowed = $batchset['BatchSet']['group_id'] == $_SESSION['Auth']['User']['group_id'];
				break;
			case 'all' :
				$allowed = true;
				break;
			default:
				AppController::getInstance()->redirect('/pages/err_datamart_system_error', null, true);
		}
		
		if(!$allowed){
			AppController::getInstance()->atimFlash('your are not allowed to work on this batchset', 'javascript:history.back()', 5);
			return false;
		}
		
		if($must_be_unlocked && $batchset['BatchSet']['locked']){
			AppController::getInstance()->atimFlash('this batchset is locked', 'javascript:history.back()', 5);
			return false;
		}
		
		return true;
	}
}

?>