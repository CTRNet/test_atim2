<?php
	$options = array(
			"links"		=> array(
				"top" => '/InventoryManagement/AliquotMasters/add/'.$sample_master_id.'/0',
				'bottom' => array('cancel' => $url_to_cancel)));

	if($is_ajax){
		$options['links']['top'] .= '/1';
	}
	$options_parent = array_merge($options, array(
		"type" => "edit",
		"settings" 	=> array("actions" => false, "form_top" => false, "form_bottom" => false, "stretch" => false, 'section_start' => $is_batch_process)));
	
	$args = AppController::getInstance()->passedArgs;
	if(isset($args['templateInitId'])){
		$override_data = array_merge(Set::flatten(AppController::getInstance()->Session->read('Template.init_data.'.$args['templateInitId'])), $override_data);
	}
	
	$options_children = array_merge($options, array(
		"type" => "addgrid",
		"settings" 	=> array("add_fields" => true, "del_fields" => true, "actions" => false, "form_top" => false, "form_bottom" => false, 'section_end' => $is_batch_process),
		"override"	=> $override_data));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$hook_link = $this->Structures->hook('loop');
		
	$first = true;
	$counter = 0;
	while($data = array_shift($this->request->data)){
		$counter++;
		$parent = $data['parent'];
		$final_options_parent = $options_parent;
		$final_options_children = $options_children;
		if($first){
			$final_options_parent['settings']['form_top'] = true;
			if(!$is_batch_process) {
				$final_options_children['settings']['form_top'] = true;
			}
			$first = false;
		}
		if(count($this->request->data) == 0){
			$final_options_children['settings']['form_bottom'] = true;
			$final_options_children['settings']['actions'] = true;
			$final_options_children['extras'] = 
				'<input type="hidden" name="data[0][realiquot_into]" value="'.$aliquot_control_id.'"/>
				<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>';
		}
		if($is_batch_process) $final_options_parent['settings']['header'] = __('aliquot creation batch process') . ' - ' . __('creation') ." #".$counter;
		$final_options_parent['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
		$final_options_parent['data'] = $parent;
		
		$final_options_children['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
		$final_options_children['data'] = $data['children'];
		
		if( $hook_link ) { 
			require($hook_link); 
		}
				
		if($is_batch_process) $this->Structures->build($sample_info, $final_options_parent);
		$this->Structures->build($atim_structure, $final_options_children);
	}
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>

<?php 
if($is_ajax){
	$display = ob_get_contents();
	ob_end_clean();
	$display = ob_get_contents().$display;
	ob_clean();
	$this->layout = 'json';
	$this->json = array('goToNext' => false, 'page' => $display, 'id' => null);
}