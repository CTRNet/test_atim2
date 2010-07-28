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
var orgAction = null;
$(function(){
	<?php if($is_datagrid){ ?>
	orgAction = $("form").attr("action");
	
	$("#submit_button").click(function(){
		return validateSubmit(false);
	});
	<?php } //end if is_datagrid ?>

	$('#hierarchy').addClass("jquery_cupertino").advMenu({
		content: $('#hierarchy').next().html(),
		backLink: false,
		flyOut: true,
		callback: function(item){
			var json = getJsonFromClass($(item).attr("class"));
			if(json != null){
				if(json.value.length > 0){
					$('#hierarchy').find(".label").html(json.label);
					$('#search_for').val(json.value);
					if(json.action){
						$("form").attr("action", json.action);
					}else{
						$("form").attr("action", orgAction);
					}
				}
			}
		}
	});

	if($("#BrowserSearchFor").length == 1){
		var parent = $("#BrowserSearchFor").parent();
		$("#BrowserSearchFor").remove();
		parent.append($("#hierarchy")).append($("#search_for"));
		getParentElement($("#hierarchy"), "TD").css("width", "100%");
	}
});

function validateSubmit(ignoreSelect){
	var errors = new Array();
	if($("#search_for").length == 1 && $("#search_for").val() == "" && !ignoreSelect){
		//TODO: traduce
		errors.push("<?php __("you must select an action"); ?>");
	}
	<?php if($is_datagrid){ ?>
	if($(":checkbox[checked=true]").length == 0){
		//TODO: traduce
		errors.push("<?php __("you need to select at least one item"); ?>");
	}
	<?php } ?>
	
	if(errors.length > 0){
		alert(errors.join("\n"));
		return false;
	}
	return true;
}
</script>




<?php 
if(isset($dropdown_options)){
	
?>
<a tabindex="0" href="#news-items" class="fg-button fg-button-icon-right ui-widget ui-state-default ui-corner-all" id="hierarchy"><span class="ui-icon ui-icon-triangle-1-s"></span><span class="label"><?php __("action"); ?></span></a>
<div class="hidden ui-widget">
<input id="search_for" type="hidden" name="data[Browser][search_for]"/>
<ul>
	<?php 
	function printList($options, $label, $webroot){
		foreach($options as $option){
			$curr_label = $label." &gt; ".$option['default'];
			$action = isset($option['action']) ? ', "action" : "'.$webroot."/".$option['action'].'" ' : "";
			echo("<li><a href='#' class='{ \"value\" : \"".$option['value']."\", \"label\" : \"".$curr_label."\" ".$action." }'>".$option['default']."</a>");
			if(isset($option['children'])){
				echo("<ul>");
				printList($option['children'], $curr_label, $webroot);
				echo("</ul>");
			}
			echo("</li>\n");
		}		
	}
	printList($dropdown_options, "", $this->webroot);
	?>
</ul>
</div>
<?php } ?>