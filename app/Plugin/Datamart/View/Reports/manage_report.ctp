<?php

	if(isset($search_form_structure)) {
		
		// ------------------------------------------
		// DISPLAY SEARCH FORM
		// ------------------------------------------
		
		$structure_links = array(
			'top'=>array(
				'search'=>'/Datamart/Reports/manageReport/' . $atim_menu_variables['Report.id']),
			'bottom'=>array(
				'reload form' => '/Datamart/Reports/manageReport/' . $atim_menu_variables['Report.id'])
		);
		
		$structure_override = array();	
		
		$final_atim_structure = $search_form_structure; 
		$final_options = array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_override);
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook();
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );
			
	} else {

		// ------------------------------------------
		// DISPLAY RESULT FORM / EXPORT REPORT (CSV)
		// ------------------------------------------
		
		if($csv_creation){
			
			//** EXPORT REPORT AS CSV **
				
			$k1 = array_keys($this->request->data);
			$k2 = array_keys($this->request->data[$k1[0]]);
			if(!is_array($this->request->data[$k1[0]][$k2[0]]) || !empty($result_columns_names)){
				//cast find first data into find all
				$this->request->data[0] = $this->request->data;
			}
			if (!empty($result_columns_names)){
				$settings['columns_names'] = $result_columns_names;
			}
			$settings['all_fields'] = true;
			$this->Structures->build($result_form_structure, array('type' => 'csv', 'data' => $this->request->data, 'settings' => $settings));
			exit;
			
		} else if(isset($linked_datamart_structure_model_name) && isset($linked_datamart_structure_key_name))  {
		
			//** DISPLAY REPORT LINKED TO DATAMART STRUCTURE AND ACTIONS **
			
			// Report
			
			$structure_links = array(
				'top'=>'#',
				'checklist'=>array("$linked_datamart_structure_model_name.$linked_datamart_structure_key_name][" => "%%$linked_datamart_structure_model_name.$linked_datamart_structure_key_name%%")
			);
			if(isset($linked_datamart_structure_links)) $structure_links['index'] = array('details' => $linked_datamart_structure_links);
			
			$add_to_batchset_hidden_field = $this->Form->input('Report.datamart_structure_id', array('type' => 'hidden', 'value' => $linked_datamart_structure_id));
			
			$settings = array('form_bottom'	=>false, 'form_inputs'	=> false, 'actions'		=> false, 'pagination'	=> false);
			if (!empty($result_header)) $settings['header'] = $result_header;
			
			$this->Structures->build( $result_form_structure, array(
				'type' 		=> 'index', 
				'data'		=> $this->request->data, 
				'settings'	=> $settings, 
				'links'	=> $structure_links,
				'extras'	=> array('end' => $add_to_batchset_hidden_field)
			));
	
			// Actions
			
			$structure_links = array('top'=>'#');
			if($display_new_search) $structure_links['bottom']['new search'] = array('link' => '/Datamart/Reports/manageReport/' . $atim_menu_variables['Report.id'], 'icon' => 'search');
			
			$this->Structures->build(array(), array(
				'type' =>'add', 
				'settings'=>array(
					'form_top'=>false, 
					'header' => __('actions', null)), 
				'links'=>$structure_links, 
				'data'=>array(),
				'extras' => array('end' => '<div id="actionsTarget"></div>')
			));
		
		} else {
			
			//** DISPLAY BASIC REPORT **
		
			$structure_links = array(
				'bottom'=>array('export as CSV file (comma-separated values)'=>sprintf("javascript:setCsvPopup('Datamart/Reports/manageReport/".$atim_menu_variables['Report.id']."/1/');", 0))
			);
			if($display_new_search) $structure_links['bottom']['new search'] = array('link' => '/Datamart/Reports/manageReport/' . $atim_menu_variables['Report.id'], 'icon' => 'search');
			
			$settings = array('form_inputs' => false, 'pagination' => false);
			if (!empty($result_header)) $settings['header'] = $result_header;
			if (!empty($result_columns_names)) $settings['columns_names'] = $result_columns_names;
			
			// BUILD FORM
			$this->Structures->build( $result_form_structure, array(
				'type'=> $result_form_type, 
				'links'=> $structure_links,
				'settings' => $settings) );
		}
	}
	
?>
<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(Sanitize::clean($linked_datamart_structure_actions)); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
</script>	