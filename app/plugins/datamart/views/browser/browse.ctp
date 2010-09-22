<?php
	if(isset($parent_node) && $parent_node != 0){
		echo(Browser::getPrintableTree($parent_node, $this->webroot));
	}

	//use add as type to avoid advanced search usage
	$settings = array();
	if($type == "checklist"){
		$links['top'] = $top;
		if(count($this->data) > 400){
			//overflow
			?>
			<ul class="error">
				<li><?php echo(__("the query returned too many results", true).". ".__("try refining the search parameters", true).". "
				.__("if you browse further ahead, all matches of the current set will be used", true)); ?>.</li>
			</ul>
			<?php
			$structures->build($empty, array('type' => 'add', 'links' => $links, 'settings' => array('actions' => false, 'form_bottom' => false))); 
			$key_parts = explode(".", $checklist_key);
			$ids = array();
			foreach($this->data as $data_unit){
				$ids[] = $data_unit[$key_parts[0]][$key_parts[1]];
			}
			echo("<input type='hidden' name='data[".$key_parts[0]."][".$key_parts[1]."]' value='".implode(',', $ids)."'/>\n");
		}else{
			//normal display
			$links['checklist'] = array(
					$checklist_key.']['=>'%%'.$checklist_key.'%%'
			);
			$structures->build($result_structure, array('type' => $type, 'links' => $links, 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false, 'form_inputs'=>false)));
		}
			$is_datagrid = true;
			$type = "add";
	}else{
		$is_datagrid = false;
	}
	$links['top'] = $top;
	$structures->build($atim_structure, array('type' => $type, 'links' => $links, 'data' => array(), 'settings' => array('form_top' => !$is_datagrid)));
?>
<script type="text/javascript">
var browser = true;
var isDatagrid = <?php echo($is_datagrid ? "true" : "false"); ?>;
var errorYouMustSelectAnAction = "<?php __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php __("you need to select at least one item"); ?>";
</script>




<?php 
if(isset($dropdown_options)){
	pr($dropdown_options);
?>
<a tabindex="0" href="#news-items" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="hierarchy"><span class="ui-icon ui-icon-triangle-1-s"></span><span class="label"><?php __("action"); ?></span></a>
<div class="hidden ui-widget">
<input id="search_for" type="hidden" name="data[Browser][search_for]"/>
<ul class='actionDropdown'>
	<?php 
	function printList($options, $label, $webroot, $loop){
		foreach($options as $option){
			$curr_label = $label." &gt; ".$option['default'];
			$curr_label_for_class = str_replace("'", "&#39;", $curr_label);
			$action = isset($option['action']) ? ', "action" : "'.$webroot."/".$option['action'].'" ' : "";
			$class = isset($option['class']) ? $option['class'] : "";
			echo("<li class='"."'><a href='#' class='{ \"value\" : \"".$option['value']."\", \"label\" : \"".$curr_label_for_class."\" ".$action." } ".$class."'>".$option['default']."</a>");
			if(isset($option['children']) && $loop){
				echo("<ul>");
				printList($option['children'], $curr_label, $webroot, $loop);
				echo("</ul>");
			}
			echo("</li>\n");
		}		
	}
	printList($dropdown_options, "", $this->webroot, $is_datagrid);
	?>
</ul>
</div>
<?php } ?>