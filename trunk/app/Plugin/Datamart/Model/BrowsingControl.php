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
		assert(count($datamart_structures) == 2);
		if($data['BrowsingControl']['id1'] == $datamart_structures[0]['DatamartStructure']['id']){
			$data['DatamartStructure1'] = $datamart_structures[0]['DatamartStructure'];
			$data['DatamartStructure2'] = $datamart_structures[1]['DatamartStructure'];
		}else{
			$data['DatamartStructure1'] = $datamart_structures[1]['DatamartStructure'];
			$data['DatamartStructure2'] = $datamart_structures[0]['DatamartStructure'];
		}
	}
	
	function getInnerJoinArray($browsing_structure_id_a, $browsing_structure_id_b, array $ids_filter = null){
		$data = $this->find('first', array('conditions' => array('BrowsingControl.id1' => $browsing_structure_id_a, 'BrowsingControl.id2' => $browsing_structure_id_b)));
		if($data){
			//n to 1
			$this->completeData($data);
			$model_n = AppModel::getInstance($data['DatamartStructure1']['plugin'], $data['DatamartStructure1']['model'], true);
			$model_1 = AppModel::getInstance($data['DatamartStructure2']['plugin'], $data['DatamartStructure2']['model'], true);
			$model_b = &$model_1;
		}else{
			//1 to n
			$data = $this->find('first', array('conditions' => array('BrowsingControl.id2' => $browsing_structure_id_a, 'BrowsingControl.id1' => $browsing_structure_id_b)));
			assert($data);
			$this->completeData($data);
			$model_n = AppModel::getInstance($data['DatamartStructure1']['plugin'], $data['DatamartStructure1']['model'], true);
			$model_1 = AppModel::getInstance($data['DatamartStructure2']['plugin'], $data['DatamartStructure2']['model'], true);
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