<?php
	if(isset($parent_node) && $parent_node != 0){
		echo(Browser::getPrintableTree($parent_node, $this->webroot));
	}
	//use add as type to avoid advanced search usage
	$settings = array();
	if($type == "checklist"){
		$is_datagrid = true;
		$links['checklist'] = array(
				$checklist_key.']['=>'%%'.$checklist_key.'%%'
		);
		$links['top'] = $top;
		$structures->build($result_structure, array('type' => $type, 'links' => $links, 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false, 'form_inputs'=>false)));
		$type = "add";
	}else{
		$is_datagrid = false;
	}
	$links['top'] = $top;
	$structures->build($atim_structure, array('type' => $type, 'links' => $links, 'data' => array()));
?>
<script type="text/javascript">
var browser = true;
var isDatagrid = <?php echo($is_datagrid ? "true" : "false"); ?>;
var errorYouMustSelectAnAction = "<?php __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php __("you need to select at least one item"); ?>";
</script>




<?php 
if(isset($dropdown_options)){
?>
<a tabindex="0" href="#news-items" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="hierarchy"><span class="ui-icon ui-icon-triangle-1-s"></span><span class="label"><?php __("action"); ?></span></a>
<div class="hidden ui-widget">
<input id="search_for" type="hidden" name="data[Browser][search_for]"/>
<ul>
	<?php 
	function printList($options, $label, $webroot, $loop){
		foreach($options as $option){
			$curr_label = $label." &gt; ".$option['default'];
			$action = isset($option['action']) ? ', "action" : "'.$webroot."/".$option['action'].'" ' : "";
			echo("<li><a href='#' class='{ \"value\" : \"".$option['value']."\", \"label\" : \"".$curr_label."\" ".$action." }'>".$option['default']."</a>");
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