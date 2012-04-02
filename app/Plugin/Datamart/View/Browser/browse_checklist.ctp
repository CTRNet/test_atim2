<?php
	if(isset($node_id) && $node_id != 0){
		echo Browser::getPrintableTree($node_id, isset($merged_ids) ? $merged_ids : array(), $this->request->webroot);
	}
	//use add as type to avoid advanced search usage
	$settings = array();
	$links['bottom']['new'] = '/Datamart/Browser/browse/';
	if(isset($is_root) && !$is_root){
		$links['bottom']['save browsing steps'] = array('link' => AppController::checkLinkPermission('/Datamart/BrowsingSteps/save/') ? 'javascript:openSaveBrowsingStepsPopup("Datamart/BrowsingSteps/save/'.$node_id.'");' : '/underdev/', 'icon' => 'disk');
	}
	
	if(isset($saved_browsing_index) && $saved_browsing_index && AppController::checkLinkPermission('/Datamart/Browser/applyBrowsingSteps/')){
		$links['bottom']['apply saved browsing steps'] = array();
		foreach($saved_browsing_index as $item){
			$links['bottom']['apply saved browsing steps'][$item['SavedBrowsingIndex']['name']] = '/Datamart/Browser/applyBrowsingSteps/'.$node_id.'/'.$item['SavedBrowsingIndex']['id'];
		}
	}else{
		$links['bottom']['apply saved browsing steps'] = '/underdev/';
	}
	
	if($type == "checklist"){
		$links['top'] = $top;
		if(is_array($this->request->data)){
			//normal display
			$links['checklist'] = array(
					$checklist_key_name.']['=>'%%'.$checklist_key.'%%'
			);
			if(isset($index) && strlen($index) > 0){
				$links['index'] = array(array('link' => $index, 'icon' => 'detail'));
			}
			$tmp_header = isset($header) ? $header : "";
			$header = __("select an action");
			$this->Structures->build($result_structure, array(
				'type'		=> "index", 
				'links'		=> $links, 
				'settings'	=> array(
					'form_bottom' 		=> false, 
					'actions' 			=> false, 
					'pagination' 		=> false, 
					'sorting' 			=> array($node_id, $control_id, $merge_to), 
					'form_inputs' 		=> false, 
					'header' 			=> $tmp_header, 
					'data_miss_warn'	=> !isset($merged_ids)
				)
			));
		}else{
			//overflow
			?>
			<ul class="warning">
				<li><?php echo(__("the query returned too many results").". ".__("try refining the search parameters").". "
				.__("for any action you take (%s, %s, csv, etc.), all matches of the current set will be used", __('browse'), __('batchset'))); ?>.</li>
			</ul>
			<?php
			$this->Structures->build($empty, array('data' => array(), 'type' => 'add', 'links' => $links, 'settings' => array('actions' => false, 'form_bottom' => false))); 
			$key_parts = explode(".", $checklist_key);
			echo("<input type='hidden' name='data[".$key_parts[0]."][".$key_parts[1]."]' value='".$this->request->data."'/>\n");
		}
		$is_datagrid = true;
		$type = "add";
		?>
		<input type="hidden" name="data[node][id]" value="<?php echo($node_id); ?>"/>
		<?php

		if($unused_parent){
			$links['bottom']['unused parents'] = '/Datamart/Browser/unusedParent/'.$node_id;
		}
	}else{
		$is_datagrid = false;
	}
	$links['top'] = $top;
	
	$extras = array('end' => '<a id="actionsTarget"></a>');
	if(isset($node_id)){
		$extras['end'] .= $this->Form->input('node.id', array('type' => 'hidden', 'value' => $node_id)); 
	}
	
	$this->Structures->build($atim_structure, array(
		'type' => $type, 
		'links' => $links, 
		'data' => array(), 
		'settings' => array(
			'form_top' => !$is_datagrid, 
			"header" => (isset($header) ? $header : __("select an action"))
		), 'extras' => $extras
	));
?>
<script>
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(Sanitize::clean($dropdown_options)); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
var STR_BACK = '<?php echo __('back'); ?>';
var csvMergeData = '<?php echo json_encode(isset($csv_merge_data) ? $csv_merge_data : array()) ; ?>';
</script>
