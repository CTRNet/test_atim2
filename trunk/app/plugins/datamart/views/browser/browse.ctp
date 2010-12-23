<?php
	if(isset($parent_node) && $parent_node != 0){
		echo(Browser::getPrintableTree($parent_node, $this->webroot));
	}
	//use add as type to avoid advanced search usage
	$settings = array();
	if($type == "checklist"){
		$links['top'] = $top;
		if(is_array($this->data)){
			//normal display
			$links['checklist'] = array(
					$checklist_key_name.']['=>'%%'.$checklist_key.'%%'
			);
			if(isset($index) && strlen($index) > 0){
				$links['index'] = array(array('link' => $index, 'icon' => 'detail'));
			}
			$tmp_header = isset($header) ? $header : "";
			$header = __("select an action", true);
			$structures->build($result_structure, array('type' => "index", 'links' => $links, 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false, 'form_inputs'=>false, 'header' => $tmp_header)));
		}else{
			//overflow
			?>
			<ul class="error">
				<li><?php echo(__("the query returned too many results", true).". ".__("try refining the search parameters", true).". "
				.__("if you browse further ahead, all matches of the current set will be used", true)); ?>.</li>
			</ul>
			<?php
			$structures->build($empty, array('type' => 'add', 'links' => $links, 'settings' => array('actions' => false, 'form_bottom' => false))); 
			$key_parts = explode(".", $checklist_key);
			echo("<input type='hidden' name='data[".$key_parts[0]."][".$key_parts[1]."]' value='".$this->data."'/>\n");
		}
		$is_datagrid = true;
		$type = "add";
		?>
		<input type="hidden" name="data[node][id]" value="<?php echo($parent_node); ?>"/>
		<?php 
	}else{
		$is_datagrid = false;
	}
	$links['top'] = $top;
	$structures->build($atim_structure, array('type' => $type, 'links' => $links, 'data' => array(), 'settings' => array('form_top' => !$is_datagrid, "header" => (isset($header) ? $header : __("select an action", true)))));
?>
<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php __("you need to select at least one item"); ?>";
</script>




<?php 
if(isset($dropdown_options)){
?>
<a tabindex="0" href="#news-items" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="hierarchy"><span class="ui-icon ui-icon-triangle-1-s"></span><span class="label"><?php __("action"); ?></span></a>
<div class="hidden ui-widget">
<input id="search_for" type="hidden" name="data[Browser][search_for]"/>
<ul class='actionDropdown'>
	<?php 
	DatamartAppController::printList($dropdown_options, "", $this->webroot);
	?>
</ul>
</div>
<?php } ?>