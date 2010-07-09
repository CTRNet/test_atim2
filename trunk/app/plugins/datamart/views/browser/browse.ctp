<?php
	if(isset($parent_node) && $parent_node != 0){
		echo(Browser::getPrintableTree($parent_node, $this->webroot));
	}
	//use add as type to avoid advanced search usage
	$settings = array();
	if($type == "checklist"){
		$is_datagrid = true;
		$links['checklist'] = array(
				'model.id]['=>'%%'.$checklist_key.'%%'
		);
		$links['top'] = $top;
		$structures->build($result_structure, array('type' => $type, 'links' => $links, 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false, 'form_inputs'=>false)));
		$type = "add";
	}else{
		$is_datagrid = false;
	}
	$links['top'] = $top;
	$structures->build($atim_structure, array('type' => $type, 'links' => $links, 'data' => array()));
	
	if($is_datagrid){
?>
<script type="text/javascript">
$(function(){
	$("#submit_button").click(function(){
		return validateSubmit(false);
	});

	<?php if($is_datagrid){ ?>
		$(".button.large").parent().append("<span id='exportCSV' class='button large'><a class='form submit'>Create BatchSet</a></span>");
		$("#exportCSV").click(function(){
			if(validateSubmit(true)){
				$("form").attr("action", root_url + "datamart/browser/createBatchSet/<?php echo($parent_node); ?>" );
				$("#submit_button").unbind("click");
				$("#submit_button").click();
			}
		}); 
	<?php } ?>
});

function validateSubmit(ignoreSelect){
	var errors = new Array();
	if($("#BrowserSearchFor").length == 1 && $("#BrowserSearchFor").val() == "" && !ignoreSelect){
		//TODO: traduce
		errors.push("You need to pick a search for");
	}
	<?php if($is_datagrid){ ?>
	if($(":checked").length < 2){
		//TODO: traduce
		errors.push("You need to select at least one item");
	}
	<?php } ?>
	
	if(errors.length > 0){
		alert(errors.join("\n"));
		return false;
	}
	return true;
}
</script>
<?php }
?>