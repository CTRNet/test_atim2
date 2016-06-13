<?php 
	
	if($csv_creation){
		// ------------------------------------------
		// EXPORT REPORT (CSV)
		// ------------------------------------------
		
		$settings = array();
		$this->Structures->build($atim_structure_for_results, array('type' => 'csv', 'data' => $diff_results_data, 'settings' => $settings));
		exit;
		
	} else {
	
		// ------------------------------------------
		// DISPLAY RESULT FORM
		// ------------------------------------------
		
		$structure_links = array(
			'top'=>'#',
			'checklist'=>array("$datamart_structure_model_name.$datamart_structure_key_name][" => "%%$datamart_structure_model_name.$datamart_structure_key_name%%")
		);
		if(isset($datamart_structure_links)) $structure_links['index'] = array('details' => $datamart_structure_links);
		
		$add_to_batchset_hidden_field = $this->Form->input('Report.datamart_structure_id', array('type' => 'hidden', 'value' => $datamart_structure_id));
		
		$this->Structures->build( $atim_structure_for_results, array(
			'type' 		=> 'index', 
			'data'		=> $diff_results_data, 
			'settings'	=>array(
				'form_bottom'	=>false, 
				'header' 		=> array('title' => __('batchset and node elements distribution description'), 'description' => __('compare').': '.$header_1.' & '.$header_2), 
				'form_inputs'	=> false, 
				'actions'		=> false, 
				'pagination'	=> false,
				'sorting' 		=> array($type_of_object_to_compare, $batch_set_or_node_id_to_compare, 0)),
			'links'	=> $structure_links,
			'extras'	=> array('end' => $add_to_batchset_hidden_field)
		));
		
		// Actions
		
		$structure_links = array('top'=>'#');
		
		$this->Structures->build(array(), array(
			'type' =>'add', 
			'settings'=>array(
				'form_top'=>false, 
				'header' => __('actions', null)), 
			'links'=>$structure_links, 
			'data'=>array(),
			'extras' => array('end' => '<div id="actionsTarget"></div>')
		));
	}
	
?>
<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(Sanitize::clean($datamart_structure_actions)); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
</script>