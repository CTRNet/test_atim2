<?php 
	
	// display adhoc DETAIL
		
	$structures->build( $atim_structure_for_detail, array('type'=>'detail', 'settings'=>array('actions'=>false), 'data'=>$data_for_detail) );

	// display adhoc RESULTS form
	$structure_links = array(
		'top'=>'#',
		'checklist'=>array(
			$data_for_detail['BatchSet']['checklist_model'].'.'.$lookup_key_name.'][' => '%%'.$data_for_detail['BatchSet']['model'].'.'.$data_for_detail['BatchSet']['lookup_key_name'].'%%'
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
	
	?>
		<input type="hidden" name="data[BatchSet][id]" value="<?php echo($atim_menu_variables['BatchSet.id']) ?>"/>
	<?php 
	$extras = array();
	if(isset($datamart_structure_id)){
		$extras = "<input type='hidden' name='data[BatchSet][datamart_structure_id]' value='".$datamart_structure_id."'/>";
	}
	$structures->build( $atim_structure_for_process, array('type'=>'add', 'settings'=>array('form_top'=>false, 'header' => __('actions', null)), 'links'=>$structure_links, 'data'=>array(), 'extras' => $extras));
		
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
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php __("you need to select at least one item"); ?>";
</script>
<a tabindex="0" href="#news-items" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="hierarchy"><span class="ui-icon ui-icon-triangle-1-s"></span><span class="label"><?php __("action"); ?></span></a>
<div class="hidden ui-widget">
<input id="search_for" type="hidden" name="data[Browser][search_for]"/>
<ul class='actionDropdown'>
	<?php 
	DatamartAppController::printList($actions, "", $this->webroot);
	?>
</ul>
</div>
