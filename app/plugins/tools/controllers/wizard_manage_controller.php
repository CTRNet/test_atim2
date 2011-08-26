<?php
class WizardManageController extends AppController {

	var $uses = array('Wizard', 'WizardNode');

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
	function index(){
		$this->set( 'atim_menu', $this->Menus->get('/menus/tools/') );
	}
	
	//produces the original display and then gets the save requests in ajax
	function edit($wizard_id){
		//the following business rules apply to received data
		//controlId	= 0 -> collection root
		//			> 0 -> sample
		//			< 0 -> aliquot
		//
		//nodeId	= 0 -> collection root node
		//			< 0 -> node not in database
		//			> 0 -> node in database
		$sample_control_model = AppModel::getInstance("Inventorymanagement", "SampleControl", true);
		$parent_to_derivative_sample_control_model = AppModel::getInstance("Inventorymanagement", "ParentToDerivativeSampleControl", true);
		$sample_controls = $sample_control_model->find('all', array('fields' => array('id', 'sample_type'), 'recursive' => -1));
		$samples_relations = $parent_to_derivative_sample_control_model->find('all', array('conditions' => array('flag_active' => 1), 'recusrive' => -1));
		foreach($sample_controls as &$sample_control){
			$sample_control['SampleControl']['sample_type'] = __($sample_control['SampleControl']['sample_type'], true);
		}
		unset($sample_control);
		foreach($samples_relations as &$sample_relation){
			unset($sample_relation['ParentSampleControl']);
			unset($sample_relation['DerivativeControl']);
		}
		unset($sample_relation);
		
		$sample_controls = AppController::defineArrayKey($sample_controls, 'SampleControl', 'id', true);
		$samples_relations = AppController::defineArrayKey($samples_relations, 'ParentToDerivativeSampleControl', 'parent_sample_control_id');
		
		$aliquot_control_model = AppModel::getInstance("Inventorymanagement", "AliquotControl", 1);
		$aliquot_controls = $aliquot_control_model->find('all', array('fields' => array('id', 'sample_control_id', 'aliquot_type'), 'conditions' => array('flag_active' => 1), 'recursive' => -1));
		foreach($aliquot_controls as &$aliquot_control){
			$aliquot_control['AliquotControl']['aliquot_type'] = __($aliquot_control['AliquotControl']['aliquot_type'], true);
		} 
		unset($aliquot_control);
		
		if(!empty($this->data)){
			//record the tree
			if($wizard_id == 0){
				//new tree
				$data = $this->Wizard->save(array('Wizard' => array('description' => 'mich')));
				$wizard_id = $this->Wizard->id;
			}
			$tree = json_decode('['.$this->data['tree'].']');
			array_shift($tree);//remove root
			$nodes_mapping = array();//for new nodes, key is the received node id, value is the db node
			$found_nodes = array();//already in db found nodes
			foreach($tree as $node){
				if($node->nodeId < 0){
					//create the node in Db
					$parent_id = null;
					if($node->parent_id < 0){
						$parent_id = $nodes_mapping[$node->parent_id];
					}
					$this->WizardNode->data = array();
					$this->WizardNode->id = null;
					$this->WizardNode->save(array('WizardNode' => array(
						'wizard_id'				=> $wizard_id,
						'parent_id'				=> $parent_id,
						'datamart_structure_id'	=> $node->controlId > 0 ? 5 : 1,
						'control_id'			=> abs($node->controlId)
					)));
					$nodes_mapping[$node->nodeId] = $this->WizardNode->id;
					$found_nodes[] = $this->WizardNode->id;
				}else{
					$found_nodes[] = $node->nodeId;
				}
			}
			
			$nodes_to_delete = $this->WizardNode->find('list', array(
				'fields'		=> array('WizardNode.id'),
				'conditions'	=> array('WizardNode.wizard_id' => $wizard_id, 'NOT' => array('WizardNode.id' => $found_nodes))
			));
			foreach($nodes_to_delete as $node_to_delete){
				$this->WizardNode->delete($node_to_delete);
			}
		}
		
		$tree = $this->WizardNode->find('all', array('conditions' => array('WizardNode.wizard_id' => $wizard_id)));
		$tree = AppController::defineArrayKey($tree, "WizardNode", "id", true);
		foreach($tree as &$node){
			$node = $node['WizardNode'];
			if(is_numeric($node['parent_id'])){
				$tree[$node['parent_id']]['children'][] = &$node;
				unset($tree[$node['id']]);
				if($node['datamart_structure_id'] == 1){
					$node['control_id'] *= -1;
				}
			} 
		}
		$tree = array(
			'id' => 0,
			'parent_id' => null,
			'control_id' => '0',
			'datamart_structure_id' => 2,
			'children' => $tree
		);
		
		$this->set('tree_data', $tree);
		$this->Structures->set('empty');
		$this->set('wizard_id', $wizard_id);
		$this->set('atim_menu', $this->Menus->get('/menus/tools/'));
		$js_data = array(
			'sample_controls' => $sample_controls, 
			'samples_relations' => $samples_relations, 
			'aliquot_controls' => AppController::defineArrayKey($aliquot_controls, "AliquotControl", "id", true),
			'aliquot_relations' => AppController::defineArrayKey($aliquot_controls, "AliquotControl", "sample_control_id")
		);
		$this->set('js_data', $js_data);
	}
}
