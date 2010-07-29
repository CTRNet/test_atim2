<?php 
	/*
	$opts = array(
		'0' => 'Inherit',
		'1' => 'Allow',
		'-1' => 'Deny'
	);
	echo $form->create('Permission', array('url' => '/administrate/permissions/tree/'.join('/',array_filter($atim_menu_variables))));
	
	$path = array();
	
	$aro_id = $aro['Aro']['id'];
	
	$i = 0;
	
	foreach($acos as $aco){
		$aco_id = intval($aco['Aco']['id']);
		
		while(count($path) && count($path) > $depth[$aco_id]) array_pop($path);
		$path[] = $aco['Aco']['alias'];
		
		if(isset($known_acos[ $aco_id ])){
			echo $form->input('Permission.'.$i.'.id', array('type' => 'hidden', 'value' => $known_acos[ $aco['Aco']['id'] ]));
			echo $form->input('Permission.'.$i.'.state', array('label' => false, 'selected' => $known_acos[ $aco['Aco']['id'] ]['_create'], 'options' => $opts, 'div' => false));
		}else{
			echo $form->input('Permission.'.$i.'.state', array('label' => false, 'selected' => 0, 'options' => $opts, 'div' => false));
		}
		echo $form->input('Permission.'.$i.'.aro_id', array('type' => 'hidden', 'value' => $aro_id));
		echo $form->input('Permission.'.$i.'.aco_id', array('type' => 'hidden', 'value' => $aco_id, 'options' => false));
		echo join('/',$path).'<br />';
		
		$i++;
	}
	echo $form->end('Save');
	*/
	
	// ATiM tree
	
	$structures_override = array(
		'Aco.state'	=>	array(
			''	=> 'Inherit',
			'1'	=> 'Allow',
			'-1'	=> 'Deny'
		)
	);
	
	$structure_links = array(
		'top'	=> '/administrate/permissions/tree/'.join('/',array_filter($atim_menu_variables))
		
		// 'index' => array(
		// 	'detail permission' => '/administrate/permissions/tree/',
		// 	'delete permission' => '/administrate/permissions/tree/'
		// )
	);
	
	$structures->build( 
		array(
			'Aco'=>$atim_structure
		),
		
		array(
			'type'		=> 'tree', 
			'links'		=> $structure_links, 
			'override'	=> $structures_override,
			
			'settings'	=> array (
				'tree'	=> array(
					'Aco'	=> 'Aco'
				),
				'header' => array ('title' => 'permission control panel', 'description' => 'note: permission changes will not take effect until the user logs out of the system.')
			)
		) 
	);
	
?>