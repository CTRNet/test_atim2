<?php 
	// display adhoc DETAIL
	$this->Structures->build( $atim_structure_for_detail, array(
		'type'		=> 'detail', 
		'settings'	=> array(
			'actions'	=> false,
			'no_sanitization'=> array('BatchSet' => array('title'))
		), 'data'=> $data_for_detail
	));

	// display adhoc RESULTS form
	$structure_links = array(
		'top'=>'#',
		'checklist'=>array(
			$lookup_model_name.'.'.$lookup_key_name.'][' => '%%'.$data_for_detail['BatchSet']['model'].'.'.$data_for_detail['BatchSet']['lookup_key_name'].'%%'
		)
	);
	
	// append LINKS from DATATABLE, if any...
	if ( count($ctrapp_form_links) ) {
		$structure_links['index'] = $ctrapp_form_links;
	}
	
	//$add_to_batchset_hidden_field = '<input type="hidden" name="data[BatchSet][id]" value="'.$data_for_detail['BatchSet']['id'].'"/>';
	$add_to_batchset_hidden_field = $this->Form->input('BatchSet.id', array('type' => 'hidden', 'value' => $data_for_detail['BatchSet']['id']));
	
	$this->Structures->build( $atim_structure_for_results, array(
		'type' 		=> 'index', 
		'data'		=> $results, 
		'settings'	=>array(
			'form_bottom'	=>false, 
			'header' 		=> __('elements', null), 
			'form_inputs'	=> false, 
			'actions'		=> false, 
			'pagination'	=> false, 
			'sorting' 		=> array($data_for_detail['BatchSet']['id'])
		), 'links'	=> $structure_links,
		'extras'	=> array('end' => $add_to_batchset_hidden_field)
	));
	
	// display adhoc-to-batchset ADD form
	$structure_links = array(
		'top'=>'#',
		'bottom'=>array(
			'edit'		=> '/Datamart/BatchSets/edit/'.$atim_menu_variables['BatchSet.id'],
			'delete'	=> '/Datamart/BatchSets/delete/'.$atim_menu_variables['BatchSet.id'],
			'list'		=> '/Datamart/BatchSets/index/'
		)
	);
	if($display_unlock_button) $structure_links['bottom'] = array_merge(array('unlock' => '/Datamart/BatchSets/unlock/'.$atim_menu_variables['BatchSet.id']), $structure_links['bottom']);

	$this->Structures->build($atim_structure_for_process, array(
		'type' =>'add', 
		'settings'=>array(
			'form_top'=>false, 
			'header' => __('actions', null)), 
		'links'=>$structure_links, 
		'data'=>array(),
		'extras' => array('end' => '<div id="actionsTarget"></div>')
	));
		
?>
<div id="popup" class="std_popup question">
	<div style="background: #FFF;">
		<h4><?php echo __("you are about to remove element(s) from the batch set"); ?></h4>
		<p>
		<?php echo __("do you wish to proceed?"); ?>
		</p>
		<span class="button confirm">
			<a class="form detail"><?php echo __("yes"); ?></a>
		</span>
		<span class="button close">
			<a class="form delete"><?php echo __("no"); ?></a>
		</span>
	</div>
</div>

<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(Sanitize::clean($actions)); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
</script>