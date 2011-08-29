<table class="structure">
	<tbody>
		<tr>
			<td>
				<table class="columns tree">
					<tbody>
						<tr>
							<td>
								<label><?php __('name'); ?></label><input type='text' name='tmp_description' value='<?php echo addslashes($description); ?>'/>
								<ul id="tree_root"></ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>

<?php 
	$structures->build($atim_structure, array('links' => array(
		'top' => '/tools/WizardManage/edit/'.$wizard_id,
		'bottom' => array(
			'list' => '/tools/WizardManage/index',
			'reset' => '/tools/WizardManage/edit/'.$wizard_id
		)))
	);
?>

<script>
	var modelsData = '<?php echo addslashes(json_encode($js_data)); ?>';
	var wizardTreeData = '<?php echo json_encode($tree_data); ?>';
	var nodeId = 0;

	function drawTree(treeData){
		modelsData = $.parseJSON(modelsData);
		drawTreeRecur(treeData, $("#tree_root"));

		$("#tree_root .delete:first").remove();

		$("input[type=submit]").click(function(){
			tree = new Array();
			$("#tree_root li").each(function(){
				tree.push(JSON.stringify($(this).data()));
			});
			$("form").append("<input type='hidden' name='data[tree]' value='" + tree + "'/>");
			$("form").append("<input type='hidden' name='data[description]' value='" + $("input[name=tmp_description]").val() + "'/>");
		});
	}

	function drawTreeRecur(treeData, node){
		var newNode = addNode(treeData, node);
		for(i in treeData.children){
			drawTreeRecur(treeData.children[i], newNode);
		}
	}

	function bindButtons(scope){
		$(scope).find(".delete").unbind('click').click(function(){
			$(getParentElement(this, "LI")).remove();
		});
		$(scope).find(".add").unbind('click').click(function(){
			if($("#addDialog").length == 0){
				buildDialog("addDialog", "", "<select></select>", new Array(
					{ "label" : STR_CANCEL, "icon" : "cancel", "action" : function(){ $("#addDialog").popup("close"); } }, 
					{ "label" : STR_OK, "icon" : "detail", "action" : function(){
							data = new Object();
							data.datamart_structure_id = $("#addDialog select").val() > 0 ? 5 : 1;
							data.children = new Array();
							data.control_id = $("#addDialog select").val();
							data.label =  $("#addDialog select option[value='" + data.control_id + "']").text();
							data.id = 0;
							data.parent_id = $("#addDialog").data("parent_id");
							addNode(data , $("#addDialog").data("node"));
						} 
					})
				);
			}
			li = getParentElement(this, "LI");
			var options = null;
			if($(li).data("datamart_structure_id") == 2){
				options = getDropdownOptions("");
			}else if($(li).data("datamart_structure_id") == 5){
				options = getDropdownOptions($(li).data("controlId"));
			}
			$("#addDialog select").html(options);
			$("#addDialog").data("node", $(getParentElement(this, "LI")));
			$("#addDialog").data("parent_id", $(getParentElement(this, "LI")).data("nodeId"));
			$("#addDialog").popup();
		});
	}
	
	function addNode(treeData, node){
		addButton = treeData.datamart_structure_id != 1 ? '<a href="#" class="form add">&nbsp;</a>' : '';
		type = null;
		label = null;
		if(treeData.datamart_structure_id == 2){
			label = '<?php __('collection'); ?>';
			type = 'collection';
		}else if(treeData.datamart_structure_id == 1){
			type = 'aliquot';
			label = modelsData.aliquot_controls[Math.abs(treeData.control_id)]["AliquotControl"]["aliquot_type"];
		}else{
			type = 'sample';
			label = modelsData.sample_controls[treeData.control_id]["SampleControl"]["sample_type"];
		}
		if($(node).find("ul").length == 0){
			$(node).append('<ul></ul>');
		}
		node = $(node).find("ul:first");
		$(node).append(
			'<li>' +
				'<div class="nodeBlock">' +
					'<div class="leftPart">- <a href="#" class="form ' + type + '">&nbsp;</a></div>' +
					'<div class="rightPart">' + addButton + '<a href="#" class="form delete noPrompt">&nbsp;</a><span class="nowrap">' + label + '</span></div>' +
				'</div>' +
				//(addButton.length > 0 ? '<ul></ul>' : '') +
			'</li>'
		);
		li = $(node).find("li:last");
		$(li).data({
			"datamart_structure_id" : treeData.datamart_structure_id, 
			"controlId" : treeData.control_id, 
			"nodeId" : treeData.id == 0 ? nodeId -- : treeData.id,
			"parent_id" : treeData.parent_id
		}); 
		bindButtons(li); 
		return li;
	}

	function getDropdownOptions(parent_id){
		var options = "";
		if(parent_id != ""){
			options += "<optgroup label='<?php __('derivative'); ?>'>";
		}
		for(i in modelsData.samples_relations[parent_id]){
			sample = modelsData.sample_controls[modelsData.samples_relations[parent_id][i]["ParentToDerivativeSampleControl"]["derivative_sample_control_id"]];
			options += "<option value='" + sample["SampleControl"]["id"] + "'>" + sample["SampleControl"]["sample_type"] + "</option>";
		}
		if(parent_id != ""){
			options += "</optgroup><optgroup label='<?php __('aliquot'); ?>'>";
		}
		for(i in modelsData.aliquot_relations[parent_id]){
			aliquot = modelsData.aliquot_relations[parent_id][i];
			options += "<option value='" + (-1 * aliquot["AliquotControl"]["id"]) + "'>" + aliquot["AliquotControl"]["aliquot_type"] + "</option>";
		}
		if(parent_id != ""){
			options += "</optgroup>";
		}
			
		return options;
	}
</script>