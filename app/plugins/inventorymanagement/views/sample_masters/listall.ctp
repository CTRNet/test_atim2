<?php 
/*	$filter_links = array( 'no filter'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['Menu.id'].'/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'] );
	foreach ( $event_controls as $event_control ) {
		$filter_links[ $event_control['EventControl']['disease_site'].' - '.$event_control['EventControl']['event_type'] ] = '/clinicalannotation/event_masters/listall/'.$atim_menu_variables['Menu.id'].'/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
	}
	
	$add_links = array();
	foreach ( $event_controls as $event_control ) {
		$add_links[ $event_control['EventControl']['disease_site'].' - '.$event_control['EventControl']['event_type'] ] = '/clinicalannotation/event_masters/add/'.$atim_menu_variables['Menu.id'].'/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
	}
*/
	$structure_links = array(
		'index' => array( 
			'detail' => '/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Menu.id'].'/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%'
		),
		'bottom' => array(
	//		'filter' => $filter_links,
	//		'add' => $add_links
		)
	); 
	
	$structures->build( $atim_structure, array('links'=>$structure_links));
/*	
	//-----------------------------------
	// 1- Display The Search Result Grid
	//-----------------------------------
	
	$form_type = 'index';

	$form_model = $sample_masters;
	$form_field = $ctrapp_form;
	$form_link = array();

	if(!$bool_include_aliquot) {
		$form_link['detail'] = '/inventorymanagement/sample_masters/detail/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.$collection_id.'/';
		$form_link['list aliquots'] =  '/inventorymanagement/aliquot_masters/listAllSampleAliquots/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.$collection_id.'/';
	} else {
		$form_link['detail'] =  '/inventorymanagement/aliquot_masters/detail/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.$collection_id.'/';
	}
	
	$form_lang = $lang;
	$form_pagination = $paging;

	$form_override = array('SampleMaster/parent_id' => $arr_sample_code_from_id);
	
	$form_extras = NULL;
	
    $forms->build( 
    	$form_type, 
    	$form_model, 
    	$form_field, 
    	$form_link, 
    	$form_lang, 
    	$form_pagination , 
    	$form_override, 
		$form_extras); 

	//-----------------------------------
	// 2- Display button to change the 
	// form layout: 
	//  - sample list plus all aliquots 
	//  - just sample list
	//-----------------------------------
	
	$action_links = array();
	
	if( $bool_include_aliquot ) {
		$action_links['switch to sample list'] = '/inventorymanagement/sample_masters/changeSampleListFormat/'.
				$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.$collection_id.'/sample+only/'.$specimen_sample_master_id.'/';
	} else {
		$action_links['switch to sample list'] = '/inventorymanagement/sample_masters/changeSampleListFormat/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.$collection_id.'/include+aliquot/'.$specimen_sample_master_id.'/';
	}
	
	//-----------------------------------
	// 3- Display Add button to create
	// either:
	//  - a new specimen
	//  - a new derivative
	//-----------------------------------

	$html_string ='';
	
	if(strcmp($sample_category, 'specimen') == 0) {	
		// Button to add specimen		
		$action_links['add'] =  '/inventorymanagement/sample_masters/add/'.
					$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$collection_id.'/';
	
	} else {	
		// Button to add derivative
		
		// Translate values
		$translated_sample_types = array();
		foreach($allowed_derived_types as $key_id => $value_type){
			$translated_sample_types[$key_id]= $translations->t($value_type, $lang, false);
		}
		
		//  Build form to select new sample type to create one sample
		if (!empty($translated_sample_types)){
			$html_string = '';
			
			$html_string .= 
				$html->formTag(
					'/inventorymanagement/sample_masters/add/'.
						$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$collection_id.'/'.$specimen_sample_master_id.'/', 
					'post',
					array('id'=>'expanded_add')
				);
			
			$html_string .= '<fieldset><select name="sample_control_id">';
	
			foreach ($translated_sample_types as $key => $value ) {
				$html_string .='<option value="'.$key.'">'.$value.'</option>';
			}
	
			$html_string .= '</select><input type="submit" class="submit add" value="'.$translations->t('add', $lang, false).'" /></fieldset></form>';
			
		}
		
	}
	
	echo $forms->generate_links_list( NULL, $action_links, $lang );
	echo ($html_string);
	
?>
*/
?>