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
		'; 
		
		$this->Structures->build( $atim_structure_for_add, array('type'=>'add', 'settings'=>array('form_top'=>false, 'header' => __('actions', null)), 'links'=>$structure_links, 'data'=>array(), 'extras' => array('end' => $extras)));
?>
<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
</script>
<a tabindex="0" href="#news-items" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="hierarchy"><span class="ui-icon ui-icon-triangle-1-s"></span><span class="label"><?php echo __("action"); ?></span></a>
<div class="hidden ui-widget">
<input id="search_for" type="hidden" name="data[Browser][search_for]"/>
<ul class='actionDropdown'>
	<?php 
	DatamartAppController::printList($actions, "", $this->request->webroot);
	?>
</ul>
</div>