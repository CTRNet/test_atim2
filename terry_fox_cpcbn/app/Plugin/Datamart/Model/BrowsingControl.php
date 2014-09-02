<?php
class BrowsingControl extends DatamartAppModel {
	var $useTable = 'datamart_browsing_controls';

	function find1ToN($elem_1_id, $elem_n_id = null){
		$conditions = array('BrowsingControl.id2' => $elem_1_id);
		if($elem_n_id){
			$conditions['BrowsingControl.id1'] = $elem_n_id;
		}
		return $this->find('all', array('conditions' => $conditions));
	}
	
	function findNTo1($elem_n_id, $elem_1_id = null){
		$conditions = array('BrowsingControl.id1' => $elem_n_id);
		if($elem_1_id){
			$conditions['BrowsingControl.id2'] = $elem_1_id;
		}
		return $this->find('all', array('conditions' => $conditions));
	}
	
	function completeData(array &$data){
		$datamart_structure_model = AppModel::getInstance('Datamart', 'DatamartStructure', true);
		$datamart_structures = $datamart_structure_model->find('all', array('conditions' => array('DatamartStructure.id' => array($data['BrowsingControl']['id1'], $data['BrowsingControl']['id2']))));
		if($data['BrowsingControl']['id1'] == $data['BrowsingControl']['id2']){
		    assert(count($datamart_structures) == 1);
		    $data['DatamartStructure1'] = $datamart_structures[0]['DatamartStructure'];
		    $data['DatamartStructure2'] = $datamart_structures[0]['DatamartStructure'];
		}else{
    		assert(count($datamart_structures) == 2);
    		if($data['BrowsingControl']['id1'] == $datamart_structures[0]['DatamartStructure']['id']){
    			$data['DatamartStructure1'] = $datamart_structures[0]['DatamartStructure'];
    			$data['DatamartStructure2'] = $datamart_structures[1]['DatamartStructure'];
    		}else{
    			$data['DatamartStructure1'] = $datamart_structures[1]['DatamartStructure'];
    			$data['DatamartStructure2'] = $datamart_structures[0]['DatamartStructure'];
    		}
		}
	}
	
	/**
	 * @param String or int $val
	 * @return If the value is a model name (string), return the id of the associated DatamartStructure. Otherwise return the value itself.
	 */
	private static function getBrowsingStructureId($val){
		if((int)$val == 0){
			$datamart_structure_model = AppModel::getInstance('Datamart', 'DatamartStructure');
			$datamart_structure = $datamart_structure_model->find('first', array('conditions' => array('OR' => array('DatamartStructure.model' => $val, 'DatamartStructure.control_master_model' => $val))));
			assert($datamart_structure);
			$val = $datamart_structure['DatamartStructure']['id'];
		}
		return $val;
	}
	
	/**
	 * @param mixed $a Either a DatamartStructure.id or a model name of the left part of the join.
	 * @param mixex $b Either a DatamartStructure.id or a model name of the right part of the join.
	 * @param array $ids_filter
	 * @return array The join array
	 */
	function getInnerJoinArray($a, $b, array $ids_filter = null){
		$browsing_structure_id_a = self::getBrowsingStructureId($a);
		$browsing_structure_id_b = self::getBrowsingStructureId($b);
		$data = $this->find('first', array('conditions' => array('BrowsingControl.id1' => $browsing_structure_id_a, 'BrowsingControl.id2' => $browsing_structure_id_b)));
		if($data){
			//n to 1
			$this->completeData($data);
			$model_n = AppModel::getInstance($data['DatamartStructure1']['plugin'], $a == $data['DatamartStructure1']['control_master_model'] ? $a : $data['DatamartStructure1']['model']);
			$model_1 = AppModel::getInstance($data['DatamartStructure2']['plugin'], $b == $data['DatamartStructure2']['control_master_model'] ? $b : $data['DatamartStructure2']['model']);
			$model_b = &$model_1;
		}else{
			//1 to n
			$data = $this->find('first', array('conditions' => array('BrowsingControl.id2' => $browsing_structure_id_a, 'BrowsingControl.id1' => $browsing_structure_id_b)));
			if(empty($data)){
			    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			assert($data);
			$this->completeData($data);
			$model_n = AppModel::getInstance($data['DatamartStructure1']['plugin'], $b == $data['DatamartStructure1']['control_master_model'] ? $b : $data['DatamartStructure1']['model']);
			$model_1 = AppModel::getInstance($data['DatamartStructure2']['plugin'], $a == $data['DatamartStructure2']['control_master_model'] ? $a : $data['DatamartStructure2']['model']);
			$model_b = &$model_n;
		}
		
		$conditions = array($model_n->name.'.'.$data['BrowsingControl']['use_field'].' = '.$model_1->name.'.'.$model_1->primaryKey);
		if($ids_filter){
			$conditions[$model_b->name.'.'.$model_b->primaryKey] = $ids_filter;
		}
		
		return array(
			'table'			=> $model_b->table,
			'alias'			=> $model_b->name,
			'type'			=> 'INNER',
			'conditions'	=> $conditions
		);
	}
}