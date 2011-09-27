<?php
class TemplateController extends AppController {

	var $uses = array('Tools.Template', 'Tools.TemplateNode', 'Group');
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
	function index(){
		$this->set('atim_menu', $this->Menus->get('/tools/Template/index'));
		$this->data = $this->Template->findOwnedNodes();
		$this->Structures->set('template');
	}

	//produces the original display and then gets the save requests in ajax
	function edit($template_id){
		//the following business rules apply to received data
		//controlId	= 0 -> collection root
		//			> 0 -> sample
		//			< 0 -> aliquot
		//
		//nodeId	= 0 -> collection root node
		//			< 0 -> node not in database
		//			> 0 -> node in database
		
		//validate access
		if($template_id != 0){
			if($this->Template->find('first', array('conditions' => array('Template.id' => $template_id, 'Template.flag_system' => 1)))){
				$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$this->Template->redirectIfNonExistent($template_id, __METHOD__, __LINE__);
		}
		
		$sample_control_model = AppModel::getInstance("Inventorymanagement", "SampleControl", true);
		$parent_to_derivative_sample_control_model = AppModel::getInstance("Inventorymanagement", "ParentToDerivativeSampleControl", true);
		$sample_controls = $sample_control_model->find('all', array('fields' => array('id', 'sample_type'), 'recursive' => -1));
		$samples_relations = $parent_to_derivative_sample_control_model->find('all', array('conditions' => array('flag_active' => 1), 'recusrive' => -1));
		AppController::applyTranslation($sample_controls, 'SampleControl', 'sample_type');
		
		foreach($samples_relations as &$sample_relation){
			unset($sample_relation['ParentSampleControl']);
			unset($sample_relation['DerivativeControl']);
		}
		unset($sample_relation);
		
		$sample_controls = AppController::defineArrayKey($sample_controls, 'SampleControl', 'id', true);
		$samples_relations = AppController::defineArrayKey($samples_relations, 'ParentToDerivativeSampleControl', 'parent_sample_control_id');
		
		$aliquot_control_model = AppModel::getInstance("Inventorymanagement", "AliquotControl", 1);
		$aliquot_controls = $aliquot_control_model->find('all', array('fields' => array('id', 'sample_control_id', 'aliquot_type'), 'conditions' => array('flag_active' => 1), 'recursive' => -1));
		AppController::applyTranslation($aliquot_controls, 'AliquotControl', 'aliquot_type'); 

		$this->Structures->set('template');
		if(!empty($this->data)){
			//correct owner/visibility if needed
			if(Template::$sharing[$this->data['Template']['visibility']] < Template::$sharing[$this->data['Template']['owner']]){
				$this->data['Template']['owner'] = $this->data['Template']['visibility'];
				AppController::addWarningMsg(__('visibility reduced to owner level', true)); 
			}
			
			//update entity
			$this->data['Template']['owning_entity_id'] = null;
			$this->data['Template']['visible_entity_id'] = null;
			$tmp = array(
				'owner' => array($this->data['Template']['owner'] => &$this->data['Template']['owning_entity_id']),
				'visibility' => array($this->data['Template']['visibility'] => &$this->data['Template']['visible_entity_id'])
			);
			
			foreach($tmp as $level){
				foreach($level as $sharing => &$value){
					switch($sharing){
						case "user":
							$value = $_SESSION['Auth']['User']['id'];
							break;
						case "bank":
							$group_data = $this->Group->findById($_SESSION['Auth']['User']['group_id']);
							$value = $group_data['Group']['bank_id'];
							break;
						default:
							$value = null;
					}
				}
			}
			unset($value);

			//record the tree
			if($template_id == 0){
				//new tree
				if($this->Template->save($this->data)){
					$template_id = $this->Template->id;
				}else{
					//non unique or empty name, give a temp one or we will lose the tree
					$errors = $this->Template->validationErrors; 
					$this->Template->save(array('Template' => array('name' => 'tmp '.now())));
					$template_id = $this->Template->id;
					$this->Template->validationErrors = $errors;
				}
			}else{
				$this->data['Template']['id'] = $template_id;
				$this->Template->save($this->data);
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
					}else if($node->parent_id > 0){
						$parent_id = $node->parent_id;
					}
					$this->TemplateNode->data = array();
					$this->TemplateNode->id = null;
					
					$this->TemplateNode->save(array('TemplateNode' => array(
						'template_id'				=> $template_id,
						'parent_id'				=> $parent_id,
						'datamart_structure_id'	=> $node->controlId > 0 ? 5 : 1,
						'control_id'			=> abs($node->controlId),
						'quantity'				=> $node->quantity
					)));
					$nodes_mapping[$node->nodeId] = $this->TemplateNode->id;
					$found_nodes[] = $this->TemplateNode->id;
				}else{
					$found_nodes[] = $node->nodeId;
					$this->TemplateNode->save(array('TemplateNode' => array('id' => $node->nodeId, 'quantity' => $node->quantity)));
				}
			}
			
			$nodes_to_delete = $this->TemplateNode->find('list', array(
				'fields'		=> array('TemplateNode.id'),
				'conditions'	=> array('TemplateNode.template_id' => $template_id, 'NOT' => array('TemplateNode.id' => $found_nodes))
			));
			$nodes_to_delete = array_reverse($nodes_to_delete);
			foreach($nodes_to_delete as $node_to_delete){
				$this->TemplateNode->delete($node_to_delete);
			}
			
			$this->atimFlash('your data has been saved', '/tools/Template/edit/'.$template_id);
			return;
		}
		$this->Template->id = $template_id;
		$this->data = $this->Template->read(); 
		$tree = $this->Template->init();
		$this->set('tree_data', $tree['']);
		$this->set('template_id', $template_id);
		$this->set('atim_menu', $this->Menus->get('/tools/Template/index'));
		$js_data = array(
			'sample_controls' => $sample_controls, 
			'samples_relations' => $samples_relations, 
			'aliquot_controls' => AppController::defineArrayKey($aliquot_controls, "AliquotControl", "id", true),
			'aliquot_relations' => AppController::defineArrayKey($aliquot_controls, "AliquotControl", "sample_control_id")
		);
		$this->set('js_data', $js_data);
		$description = null;
		if($template_id != 0){
			$template = $this->Template->findById($template_id);
			$description = $template['Template']['name'];
		}else{
			$description = '';
		}
		$this->set('template_id', $template_id);
		$this->set('description', $description);
		$this->set('controls', 1);
		$this->set('collection_id', 0);
		
		$this->render('tree');
	}
	
	function delete($template_id){
		$nodes_to_delete = $this->TemplateNode->find('list', array(
			'fields'		=> array('TemplateNode.id'),
			'conditions'	=> array('TemplateNode.template_id' => $template_id)
		));
		$nodes_to_delete = array_reverse($nodes_to_delete);
		foreach($nodes_to_delete as $node_to_delete){
			$this->TemplateNode->delete($node_to_delete);
		}
		$this->Template->delete($template_id);
		
		$this->flash('your data has been deleted', '/tools/Template/index/');
	}
}
