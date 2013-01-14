<?php
	// display adhoc RESULTS form
		
		$structure_links = array(
			'top'=>'/Datamart/adhocs/process',
			'checklist' => array(
				$checklist_key.'][' => '%%'.$data_for_detail['Adhoc']['model'].'.id'.'%%'
			)
		);
		
		// append LINKS from DATATABLE, if any...
		if ( count($ctrapp_form_links) ) {
			$structure_links['index'] = $ctrapp_form_links;
		}
		$this->Structures->build( $atim_structure_for_results, array('type'=>'index', 'data'=>$results, 'settings'=>array('form_bottom'=>false, 'form_inputs'=>false, 'actions'=>false, 'pagination'=>false, 'header' => array('title' => __('result', null), 'description' => sizeof($results).' '. __('elements'))), 'links'=>$structure_links) );
	
		// display adhoc-to-batchset ADD form
		$structure_links = array(
			'top'=>'#',
			'bottom'=>array(
				'back to search'=>'/Datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']
			)
		);
		
		$extras = '
			<input type="hidden" name="data[Adhoc][id]" value="'.$atim_menu_variables['Adhoc.id'].'"/>
			<div id="actionsTarget"></div>
		'; 
		
		$this->Structures->build( array(), array('type'=>'add', 'settings'=>array('form_top'=>false, 'header' => __('actions', null)), 'links'=>$structure_links, 'data'=>array(), 'extras' => array('end' => $extras)));
?>
<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(Sanitize::clean($actions)); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
</script>
