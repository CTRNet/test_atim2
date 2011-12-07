<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/quality_ctrls/edit/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
			.$atim_menu_variables['QualityCtrl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/quality_ctrls/detail/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links' => $structure_links,
		'type'	=> 'edit',
		'settings' => array(
			'form_bottom'	=> false,
			'actions'		=> false
		)
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

	
	
	
	//aliquot part
	$aliquot_master_id = $this->data['QualityCtrl']['aliquot_master_id'];
	$na_checked = true;
	foreach($aliquot_data_vol as &$aliquot_data_unit){
		if($aliquot_data_unit['AliquotMaster']['id'] == $aliquot_master_id){
			$aliquot_data_unit['QualityCtrl']['aliquot_master_id'] = $aliquot_master_id;
			$na_checked = false;
			break;
		}
	}
	if($na_checked){
		foreach($aliquot_data_no_vol as &$aliquot_data_unit){
			if($aliquot_data_unit['AliquotMaster']['id'] == $aliquot_master_id){
				$aliquot_data_unit['QualityCtrl']['aliquot_master_id'] = $aliquot_master_id;
				$na_checked = false;
				break;
			}
		}
	}
	
	$structure_links['radiolist'] = array('QualityCtrl.aliquot_master_id' => '%%AliquotMaster.id%%');
	$final_atim_structure = $aliquot_structure;
	$final_options = array(
		'links'	=> $structure_links,
		'type'	=> 'index',
		'data'	=> array_merge($aliquot_data_vol, $aliquot_data_no_vol),
		'settings'	=> array(
			'form_top'		=> false,
			'pagination'	=> false,
			'header'		=> __('used aliquot', true),
			'form_inputs'	=> false,
			'actions'		=> false,
			'form_bottom'	=> false
		)
	);
	
	$hook_link = $structures->hook('aliquot');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$structures->build( $final_atim_structure, $final_options );

	?>
		<table class="structure"><tbody><tr>
			<td style='text-align: left; padding-left: 10px;'>
			
 				<?php echo $this->Form->radio('QualityCtrl.aliquot_master_id', array('na' => 'N/A'), array('legend'=>false, 'value'=>false, 'checked' => $na_checked)); ?>
 				
			</td>
		</tr></tbody></table>
	<?php
	
	
	$final_atim_structure = array('Structure' => array('alias' => ''), 'Sfs' => array());
	$final_options = array(
			'links'	=> $structure_links,
			'type'	=> 'detail',
			'data'	=> array(),
			'settings'	=> array(
				'form_top'		=> false,
				'pagination'	=> false,
				'form_inputs'	=> false
		)
	);
	
	$hook_link = $structures->hook('no_aliquot');
	if( $hook_link ) {
		require($hook_link);
	}
	$structures->build( $final_atim_structure, $final_options );
	
	$aliquot_vol_ids = array(0);
	foreach($aliquot_data_vol as $aliquot_unit){
		$aliquot_vol_ids[] = $aliquot_unit['AliquotMaster']['id'];
	}
?>
<script>
	var volumeIds = new Array("<?php echo implode('", "', $aliquot_vol_ids); ?>");
</script>