<?php 
	
	// display adhoc DETAIL
	
		$structures->build( $atim_structure_for_detail, array('type'=>'detail', 'settings'=>array('actions'=>false), 'data'=>$data_for_detail) );
	
	// display adhoc RESULTS form
		
		$structure_links = array(
			'top'=>'/datamart/batch_sets/process/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['BatchSet.id'],
			'checklist'=>array(
				$data_for_detail['BatchSet']['model'].'.id]['=>'%%'.$data_for_detail['BatchSet']['model'].'.id'.'%%'
			)
		);
		
		// append LINKS from DATATABLE, if any...
		if ( count($ctrapp_form_links) ) {
			$structure_links['index'] = $ctrapp_form_links;
		}
		
		$structures->build( $atim_structure_for_results, array('type'=>'checklist', 'data'=>$results, 'settings'=>array('form_bottom'=>false, 'form_inputs'=>false, 'actions'=>false, 'pagination'=>false), 'links'=>$structure_links) );
	
	// display adhoc-to-batchset ADD form
	
		$structure_links = array(
			'top'=>'#',
			'bottom'=>array(
				'edit'=>'/datamart/batch_sets/edit/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['BatchSet.id'],
				'delete'=>'/datamart/batch_sets/delete/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['BatchSet.id'],
				'list'=>'/datamart/batch_sets/index/'.$atim_menu_variables['Param.Type_Of_List']
			)
		);
		
		$structure_override = array(
			'BatchSet.process' => $batch_set_processes
		);
		
		$structures->build( $atim_structure_for_process, array('type'=>'add', 'settings'=>array('form_top'=>false), 'links'=>$structure_links, 'override'=>$structure_override, 'data'=>array()) );
?>
