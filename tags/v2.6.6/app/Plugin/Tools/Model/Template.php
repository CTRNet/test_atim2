<?php 
class Template extends AppModel {
	
	var $useTable = 'templates';
	var $tree = null;

	static $sharing = array(
		'user'	=> 0,
		'bank'	=> 1,
		'all'	=> 2
	);
	
	function init(){
		$template_node_model = AppModel::getInstance("Tools", "TemplateNode", true);
		$tree = $template_node_model->find('all', array('conditions' => array('TemplateNode.Template_id' => $this->id)));
		$result[''] = array(
			'id' => 0,
			'parent_id' => null,
			'control_id' => '0',
			'datamart_structure_id' => 2,
			'quantity' => 1,
			'children' => array()
		);
		foreach($tree as &$node){
			$node = $node['TemplateNode'];
			$result[$node['id']] = $node;
			$result[$node['parent_id']]['children'][] = &$result[$node['id']];
		}
		
		return $result;
	}
	
	/*
	 * Get tamplate(s) list based on use definition.
	 * When $template_id is set, system defined if template properties can be edited or not by the user
	 *   (Only user who created the template or administrators can change template properties or delete)
	 */
	function getTemplates($use_defintion, $template_id = null) {
		$conditions = array();
		$find_type = $template_id? 'first' : 'all';
		switch($use_defintion) {
			case 'template edition':
				$conditions = array(
					'OR' => array(
						array('Template.owner' => 'user', 'Template.owning_entity_id' => AppController::getInstance()->Session->read('Auth.User.id')),
						array('Template.owner' => 'bank', 'Template.owning_entity_id' => AppController::getInstance()->Session->read('Auth.User.group_id')),
						array('Template.owner' => 'all')),			
					// Both active and inactive template
					'Template.flag_system' => false);
				if(AppController::getInstance()->Session->read('Auth.User.group_id') == '1') unset($conditions['OR']);	// Admin can work on all templates
				if($template_id) $conditions['Template.id'] = $template_id;
				break;
			
			case 'template use':
				$conditions = array(
					'OR' => array(
						array('Template.visibility' => 'user', 'Template.visible_entity_id' => AppController::getInstance()->Session->read('Auth.User.id')),
						array('Template.visibility' => 'bank', 'Template.visible_entity_id' => AppController::getInstance()->Session->read('Auth.User.group_id')),
						array('Template.visibility' => 'all'),
						array('Template.flag_system' => true)),
					'Template.flag_active' => 1);	
				break;
				
			default:
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
		}
		
		$templates = $this->find($find_type, array('conditions' =>  $conditions));
		if($templates && $find_type == 'first') {
			$templates['Template']['allow_properties_edition'] = ((AppController::getInstance()->Session->read('Auth.User.group_id') == 1) || (AppController::getInstance()->Session->read('Auth.User.id') == $templates['Template']['created_by']));
		}
		return $templates;
	}
	
	/*
	 * Get code for 'Add From Template' button to build collection content from template
	 */
	function getAddFromTemplateMenu($collection_id){
		$visible_nodes = $this->getTemplates('template use');
		$options['empty template'] = array(
				'icon' => 'add',
				'link' => '/InventoryManagement/Collections/template/'.$collection_id.'/0'
		);
		foreach($visible_nodes as $template){
			$options[$template['Template']['name']] = array(
					'icon' => 'template',
					'link' => '/InventoryManagement/Collections/template/'.$collection_id.'/'.$template['Template']['id']
			);
		}
	
		return $options;
	}
	
	function setOwnerAndVisibility(&$tempate_data, $created_by = null) {
		if(Template::$sharing[$tempate_data['Template']['visibility']] < Template::$sharing[$tempate_data['Template']['owner']]){
			$tempate_data['Template']['owner'] = $tempate_data['Template']['visibility'];
			AppController::addWarningMsg(__('visibility reduced to owner level'));
		}
	
		
		//Get template user & group ids--------------
		$template_user_id = AppController::getInstance()->Session->read('Auth.User.id');
		$template_group_id = AppController::getInstance()->Session->read('Auth.User.group_id');
		if($created_by && $created_by != $template_user_id) {
			// Get real tempalte owner and group in case admiistrator is changing data
			$template_user_id = $created_by;
			
			$user_model = AppModel::getInstance("", "User", true);
			$template_user_data = $user_model->find('first', array('conditions' => array('User.id' => $created_by, 'User.deleted' => array(0,1))));
			$template_user_id = $template_user_data['User']['id'];
			$template_group_id = $template_user_data['Group']['id'];
		}
		
		
		//update entities----------
		$tempate_data['Template']['owning_entity_id'] = null;
		$tempate_data['Template']['visible_entity_id'] = null;
		$tmp = array(
			'owner' => array($tempate_data['Template']['owner'] => &$tempate_data['Template']['owning_entity_id']),
			'visibility' => array($tempate_data['Template']['visibility'] => &$tempate_data['Template']['visible_entity_id'])
		);
	
		foreach($tmp as $level){
			foreach($level as $sharing => &$value){
				switch($sharing){
					case "user":
						$value = $template_user_id;
						break;
					case "bank":
						$value = $template_group_id;
						break;
					case "all":
						$value = '0';
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
				}
			}
		}
		
		$this->addWritableField(array('owning_entity_id', 'visible_entity_id'));
	}
}
