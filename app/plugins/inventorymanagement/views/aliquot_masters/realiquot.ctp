<?php
	$final_options = array('type'=>'radiolist', 'data'=>$diagnosis_data, 'settings'=>array('form_bottom'=>true, 'form_top'=>true, 'form_inputs'=>false, 'actions'=>true, 'pagination'=>false, 'header' => __('diagnosis', true), 'form_bottom' => false, 'actions' => false, 'separator' => true), 'links'=>$structure_links);

	$final_options = array(
		'settings' => array(
			'form_bottom' => false,
			'actions' => false),
		'links' => array(
			'top' => '/inventorymanagement/aliquot_masters/realiquot/'.$batch_set_id.'/true')
	);
	$structures->build($empty, $final_options);
	
	$final_options = array(
		'settings' => array(
			'form_bottom' => false,
			'actions' => false,
			'pagination' => false),
		'type' => 'index'
	);
	$tabindex = 0;
	foreach($aliquots as $aliquot){
		$final_options['data'][] = $aliquot;
		$final_structure = $aliquots_listall_structure;
		$structures->build($final_structure, $final_options);
		foreach($aliquot['RealiquotingControl'] as $key => $val){
			$tabindex += 100;
			$final_structure = ${$aliquot_controls[$key]};
			$final_options['type'] = 'datagrid';
			$final_options['settings']['add_fields'] = true;
			$final_options['settings']['del_fields'] = true;
			$final_options['settings']['name_prefix'] = "_".$aliquot['AliquotMaster']['id']."_".$key;
			$final_options['settings']['tabindex'] = $tabindex;
			$final_options['override'] = array("AliquotMaster.aliquot_type" => $val);
			if($final_structure['Structure']['volume_unit']){
				$final_options['override']['AliquotMaster.aliquot_volume_unit'] = $final_structure['Structure']['volume_unit']; 
			}
			unset($final_options['settings']['separator']);
			unset($final_options['data']);
			$final_options['data'] = array();
			$none = true;
			foreach($this->data as $data_unit){
				if(isset($data_unit["_".$aliquot['AliquotMaster']['id']."_".$key])){
					$final_options['data'][] = array();
					$none = false;
				}
			}
			if($none){
				$final_options['data'][] = array();
			}
			$final_options['links']['top'] = '/inventorymanagement/aliquot_masters/realiquot/'.$batch_set_id.'/true';
			$structures->build($final_structure, $final_options);
		}
		$final_options = array(
		'settings' => array(
			'form_bottom' => false,
			'actions' => false,
			'pagination' => false,
			'separator' => true),
		'type' => 'index'
		);
	}
	unset($final_options['settings']['separator']);
	$final_options = array(
		'settings' => array(
			'form_top' => false,
			'form_bottom' => true,
			'actions' => true
		),
		'links' => array(
			'top' => '/inventorymanagement/aliquot_masters/realiquot/'.$batch_set_id.'/true'
		)
	);
	$structures->build($empty, $final_options);
?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
</script>

<?php 
	echo $javascript->link('copyControl')."\n";
//	pr($this->data);
?>
<div id="debug"></div>
