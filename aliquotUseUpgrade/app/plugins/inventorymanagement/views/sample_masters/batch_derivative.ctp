<?php
	$options = array(
		'type' 		=> 'addgrid',
		'links'		=> array(
			'top'		=> '/inventorymanagement/sample_masters/batchDerivative/'),
		'settings'	=> array(
			'form_top'		=> false,
			'form_bottom'	=> false,
			'actions'		=> false,
			"add_fields" 	=> true, 
			"del_fields" 	=> true),
		'override'	=> array(
			'SampleMaster.sample_type'		=> $control['SampleControl']['sample_type'],
			'SampleMaster.sample_category'	=> $control['SampleControl']['sample_category'])
	);
	$first = true;
	while($data = array_shift($this->data)){
		$final_options = $options;
		if($first){
			$final_options['settings']['form_top'] = true;
			$first = false;
		}
		if(empty($this->data)){
			$final_options['settings']['form_bottom'] = true;
			$final_options['settings']['actions'] = true;
			$final_options['extras'] = '<input type="hidden" name="data[SampleMaster][sample_control_id]" value="'.$control['SampleControl']['id'].'"/>';
		}
		$final_options['settings']['name_prefix'] = $data['parent']['SampleMaster']['id'];	
		$final_options['settings']['header'] = sprintf(__('derivatives for sample [%s]', true), $data['parent']['SampleMaster']['sample_code']);
		$final_options['data'] = $data['children'];
		$final_options['dropdown_options']['SampleMaster.parent_id'] = array($data['parent']['SampleMaster']['id'] => $data['parent']['SampleMaster']['sample_code']);
		$structures->build($atim_structure, $final_options);
	}
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>
