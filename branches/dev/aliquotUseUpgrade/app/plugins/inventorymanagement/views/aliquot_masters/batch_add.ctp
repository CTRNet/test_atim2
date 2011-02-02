<?php
	$options = array(
		'type' 	=> 'addgrid',
		'links' => array(
			'top' => '/inventorymanagement/aliquot_masters/batchAdd/'
		),
		'settings' => array(
			'form_top' 		=> false,
			'form_bottom' 	=> false,
			'actions' 		=> false,
			'add_fields' 	=> true, 
			'del_fields' 	=> true
		),
		'override' => array(
			'AliquotMaster.aliquot_type' => $aliquot_control['aliquot_type'],
			'AliquotMaster.aliquot_volume_unit' => $aliquot_control['volume_unit']
		)
	);
	
	$first = true;
	while($data = array_shift($this->data)){
		$final_options = $options;
		if($first){
			$first = false;
			$final_options['settings']['form_top'] = true;
		}
		if(count($this->data) == 0){
			$final_options['settings']['form_bottom'] = true;
			$final_options['settings']['actions'] = true;
			$final_options['extras'] = '<input type="hidden" name="data[0][realiquot_into]" value="'.$aliquot_control['id'].'"/>';
		}
		$final_options['settings']['name_prefix'] = $data['parent']['SampleMaster']['id'];
		$final_options['data'] = $data['children'];
		$final_options['settings']['header'] = sprintf(__("aliquots for sample [%s]", true), $data['parent']['SampleMaster']['sample_code']);
		$structures->build($atim_structure, $final_options);
	}
?>
<script>
var copyControl = true;
</script>