<?php
	if(isset($node_id) && $node_id != 0){
		echo Browser::getPrintableTree($node_id, isset($merged_ids) ? $merged_ids : array(), $this->request->webroot);
	}
	//use add as type to avoid advanced search usage
	$settings = array('header' => $header);
	$links['bottom']['new'] = '/Datamart/Browser/browse/';
	$links['top'] = $top;
	
	$extras = array();
	if(isset($node_id)){
		$extras['end'] = $this->Form->input('node.id', array('type' => 'hidden', 'value' => $node_id)); 
	}
	if(isset($advanced_structure)){
		$settings['form_bottom'] = false;
		$settings['actions'] = false;
	}
	
	$this->Structures->build($atim_structure, array(
		'type' => 'search', 
		'links' => $links, 
		'data' => array(), 
		'settings' => $settings, 
		'extras' => isset($advanced_structure) ? '' : $extras
	));
	
	if(isset($advanced_structure)){
		$settings['form_bottom'] = true;
		$settings['actions'] = true;
		unset($settings['header']);
		$settings['language_heading'] = __('special parameters');
		$dropdown_options = array();
		
		foreach($advanced_structure['Sfs'] as $sfs){
			if(isset($sfs['filtered_options'])){
				$dropdown_options[$sfs['model'].'.'.$sfs['field']] = $sfs['filtered_options'];
			}
		}
		
		$this->Structures->build($advanced_structure, array(
				'type' => 'search',
				'links' => $links,
				'data' => array(),
				'settings' => $settings,
				'extras' => $extras,
				'dropdown_options' => $dropdown_options
		));
	}
