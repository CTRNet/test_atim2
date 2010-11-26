<?php 
	
	// display adhoc DETAIL
		
	$structures->build( $atim_structure_for_detail, array('type'=>'detail', 'settings'=>array('actions'=>false), 'data'=>$data_for_detail) );
	
	// display adhoc RESULTS form
	$structure_links = array(
		'top'=>'#',
		'checklist'=>array(
			$data_for_detail['BatchSet']['model'].'.'.$lookup_key_name.'][' => '%%'.$data_for_detail['BatchSet']['model'].'.'.$lookup_key_name.'%%'
		)
	);
	
	// append LINKS from DATATABLE, if any...
	if ( count($ctrapp_form_links) ) {
		$structure_links['index'] = $ctrapp_form_links;
	}
	
	$structures->build( $atim_structure_for_results, array('type' => 'index', 'data'=>$results, 'settings'=>array('form_bottom'=>false, 'header' => __('elements', null), 'form_inputs'=>false, 'actions'=>false, 'pagination'=>false), 'links'=>$structure_links) );
	
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
		'BatchSet.id' => $atim_menu_variables['BatchSet.id']
	);
	
	?>
		<input type="hidden" name="data[BatchSet][id]" value="<?php echo($atim_menu_variables['BatchSet.id']) ?>"/>
	<?php 
	
	$structures->build( $atim_structure_for_process, array('type'=>'add', 'settings'=>array('form_top'=>false, 'header' => __('actions', null)), 'links'=>$structure_links, 'override'=>$structure_override, 'data'=>array()) );
		
?>
<div id="popup" class="std_popup question">
	<div style="background: #FFF;">
		<h4><?php __("you are about to remove element(s) from the batch set"); ?></h4>
		<p>
		<?php __("do you wish to proceed?"); ?>
		</p>
		<span class="button confirm">
			<a class="form detail"><?php __("yes"); ?></a>
		</span>
		<span class="button close">
			<a class="form delete"><?php __("no"); ?></a>
		</span>
	</div>
</div>

<script type="text/javascript">
var batchSetControls = true;
var batchSetFormActionMsgSelectAnOption = "<?php __("select an option for the field process batch set") ?>";
var batchSetFormActionMsgSelectAtLeast = "<?php __("check at least one element from the batch set") ?>";
</script>
<?php 
echo $javascript->link('batchset')."\n";