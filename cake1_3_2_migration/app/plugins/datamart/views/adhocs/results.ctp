<?php
	// display adhoc DETAIL
		$structures->build( $atim_structure_for_detail, array('type'=>'detail', 'settings'=>array('actions'=>false), 'data'=>$data_for_detail) );
	
	// display adhoc RESULTS form
		
		$structure_links = array(
			'top'=>'/datamart/adhocs/process',
			'checklist' => array(
				$data_for_detail['Adhoc']['model'].'.id]['=>'%%'.$data_for_detail['Adhoc']['model'].'.id'.'%%'
			)
		);
		
		// append LINKS from DATATABLE, if any...
		if ( count($ctrapp_form_links) ) {
			$structure_links['index'] = $ctrapp_form_links;
		}
		$structures->build( $atim_structure_for_results, array('type'=>'checklist', 'data'=>$results, 'settings'=>array('form_bottom'=>false, 'form_inputs'=>false, 'actions'=>false, 'pagination'=>false), 'links'=>$structure_links) );
	
	// display adhoc-to-batchset ADD form
	
		// include SAVE button
		if ( $atim_menu_variables['Param.Type_Of_List']!='saved' && $save_this_search_data ) {
			$structure_links = array(
				'top'=>'#',
				'bottom'=>array(
					'add as saved search'=>'/datamart/adhoc_saved/add/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'],
					'search'=>'/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']
				)
			);
		}
		
		else {
			$structure_links = array(
				'top'=>'#',
				'bottom'=>array(
					'search'=>'/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']
				)
			);
		}
		
		$structure_override = array(
			'Adhoc.id' => $atim_menu_variables['Adhoc.id'],
			'Adhoc.sql_query_for_results' => $final_query,
			'Adhoc.process' => $batch_sets,
			'BatchSet.id' => $compatible_batchset
		);
		
		$structures->build( $atim_structure_for_add, array('type'=>'add', 'settings'=>array('form_top'=>false), 'links'=>$structure_links, 'override'=>$structure_override, 'data'=>array()) );
?>