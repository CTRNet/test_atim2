<!-- 
<table class="structure">
	<tr>
		<td>
			Start by browsing: 
			<select>
				<option></option>
				<option>a</option>
			</select>
		
		</td>
	</tr>
</table>
<div class="actions">
</div>
 -->
 
<?php 
	//use add as type to avoid advanced search usage
	$settings = array();
	if($type == "checklist"){
		$js_check = true;
		$links['checklist'] = array(
				'model.id]['=>'%%'.$checklist_key.'%%'
		);
		$links['top'] = $top;
		$structures->build($result_structure, array('type' => $type, 'links' => $links, 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false, 'form_inputs'=>false)));
		$type = "add";
	}else{
		$js_check = false;
	}
	$links['top'] = $top;
	$structures->build($atim_structure, array('type' => $type, 'links' => $links, 'data' => array()));
	
	if($js_check){
?>
<script type="text/javascript">
$(function(){
	$("#submit_button").click(function(){
		var errors = new Array();
		if($("#BrowserSearchFor").length == 1 && $("#BrowserSearchFor").val() == ""){
			//TODO: traduce
			errors.push("You need to pick a search for");
		}
		<?php if($js_check){ ?>
		if($(":checked").length < 2){
			//TODO: traduce
			errors.push("You need to select at least one item");
		}
		<?php } ?>
		
		if(errors.length > 0){
			alert(errors.join("\n"));
			return false;
		}
	});
});
</script>
<?php }
?>