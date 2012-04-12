<?php
$tree_html = 
'<table class="structure">
	<tbody>
		<tr>
			<td>
				<table class="columns tree">
					<tbody>
						<tr>
							<td>
								<ul class="tree_root"></ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>';
$final_options = array();
if($controls){
	$final_options = array(
		'type' => 'edit',
		'links' => array(
			'top' => '/Tools/Template/edit/'.$template_id,
			'bottom' => array(
				'list' => '/Tools/Template/index',
				'reset' => array('link' => 'javascript:confirmReset();', 'icon' => 'redo')
			)
		), 'settings' => array('return' => true, 'form_bottom' => true),
		'extras' => $tree_html
	);
	if(isset($is_ajax)){
		$final_options['settings']['actions'] = false;
	}
}else{
	$final_options = array(
		'type' => 'detail',
		'extras' => 
			"<div style='padding-left: 10px;'><label>". __('auto submit') ."</label><input type='checkbox' name='autosubmit'/></div>"
			.$tree_html
			."<div class='ajaxContent'></div>",
		'settings' => array('return' => true)
	);
	if(isset($structure_header)) {
		$final_options['settings']['header'] = $structure_header;
	}
}

$final_atim_structure = $atim_structure;
$page = $this->Structures->build( $final_atim_structure, $final_options );

if(isset($is_ajax)){
	$page = $this->Shell->validationHtml().$page;
	$tmp = $this->Shell->validationErrors();
	$has_errors = !empty($tmp);
	$this->validationErrors = array();
	echo json_encode(array('page' => $page, 'has_errors' => $has_errors));
	return;
}else{
	echo $page;
}

?>

<script>
	var STR_ADD = "<?php echo __('add'); ?>";
	var modelsData = '<?php echo addslashes(json_encode($js_data)); ?>';
	var wizardTreeData = '<?php echo json_encode($tree_data); ?>';
	var nodeId = 0;
	var collectionId = <?php echo isset($collection_id) ? $collection_id : null; ?>;

	function drawTree(treeData){
		modelsData = $.parseJSON(modelsData);
		drawTreeRecur(treeData, $(".tree_root"));

		$(".tree_root .delete:first").remove();

		$("input[type=submit]").click(function(){
			tree = new Array();
			$(".tree_root li").each(function(){
				tree.push(JSON.stringify($(this).data()));
			});
			
			$("form").append("<input type='hidden' name='data[tree]' value='" + tree + "'/>");
			$("form").append("<input type='hidden' name='data[description]' value='" + $("input[name=tmp_description]").val() + "'/>");

			//posting the tree
			$.post($("form").attr("action"), $("form").serialize(), function(data){
				data = $.parseJSON(data);
				$("body").append("<div class='hidden' id='tmp_add'></div>");
				$("#tmp_add").html(data.page);
				$("form:first").attr("action", $("#tmp_add form").attr("action")).find("table:first").replaceWith($("#tmp_add table:first"));
				$(".wrapper").find(".validation").remove();
				$(".wrapper").prepend($(".validation"));
				$("#tmp_add").remove();
				if(!data.has_errors){
					$("form").submit();
				}
			});
			
			return false;
		});

		if(!<?php echo $controls; ?>){
			//wizard mode
			initWizardMode(<?php echo $template_id; ?>);
		}

		setTimeout(dataSavedFadeout, 3500);
	}

	function drawTreeRecur(treeData, node){
		var newNode = addNode(treeData, node);
		for(i in treeData.children){
			drawTreeRecur(treeData.children[i], newNode);
		}
	}

	function numberValidation(field, valueIfWrong){
		var val = $(field).val();
		var wrong = (isNaN(parseInt(val)) || val != parseInt(val) || parseInt(val) < 1) &&  
			val.trim().length > 0;

		if(wrong){
			flashColor($(field), "#F00");
			if(valueIfWrong != null){
				$(field).val(valueIfWrong);
			}
		}
		
		return !wrong;
	}

	function bindButtons(scope){
		$(scope).find(".delete").unbind('click').click(function(){
			var parentLi = $(this).parents("li:first"); 
			if($(currentNode).data() == $(parentLi).data()){
				$(parentLi).find("ul:first").remove();
				nextNode();
			}
			if($(parentLi).parent().children().length == 1){
				//only child, remove the whole UL
				$(parentLi).parent().remove();
			}else{
				$(parentLi).remove();
			}
			return false;
		});
		$(scope).find(".add").unbind('click').click(function(){
			if($("#addDialog").length == 0){
				buildDialog("addDialog", "", "<select></select><input type='number' size='1' min='1' max='50'></input>", new Array( 
					{ "label" : STR_ADD, "icon" : "add", "action" : function(){
							if(numberValidation($("#addDialog input"), null)){
								data = new Object();
								data.datamart_structure_id = $("#addDialog select").val() > 0 ? 5 : 1;
								data.children = new Array();
								data.control_id = $("#addDialog select").val();
								data.label =  $("#addDialog select option[value='" + data.control_id + "']").text();
								data.id = 0;
								data.parent_id = $("#addDialog").data("parent_id");
								data.quantity = isNaN(parseInt($("#addDialog input").val())) ? 1 : $("#addDialog input").val();
								addNode(data , $("#addDialog").data("node"));
							}
							return false;
						} 
					})
				);
			}
			li = $(this).parents("li:first");
			var options = null;
			if($(li).data("datamart_structure_id") == 2){
				options = getDropdownOptions("");
			}else if($(li).data("datamart_structure_id") == 5){
				options = getDropdownOptions($(li).data("controlId"));
			}

			updateNumInput = function(){
				if($("#addDialog select").val() > 0){
					$("#addDialog input").attr("disabled", true).val("1");
				}else{
					$("#addDialog input").attr("disabled", false);
				}  
			};
			
			$("#addDialog select").html(options).change(updateNumInput);
			var liParent = $(this).parents("li:first");
			$("#addDialog").data("node", liParent);
			$("#addDialog").data("parent_id", $(liParent).data("nodeId"));
			updateNumInput();
			$("#addDialog").popup();
			return false;
		});
	}
	
	function addNode(treeData, node){
		addButton = treeData.datamart_structure_id != 1 && <?php echo isset($flag_system) && $flag_system ? 'false' : 'true' ?> ? '<a href="#" class="icon16 add">&nbsp;</a>' : '';
		type = null;
		label = null;
		if(treeData.datamart_structure_id == 2){
			label = '<?php echo __('collection'); ?>';
			type = 'collection';
		}else if(treeData.datamart_structure_id == 1){
			type = 'aliquot';
			label = modelsData.aliquot_controls[Math.abs(treeData.control_id)]["AliquotControl"]["aliquot_type"] + " <input type='number' size='1' min='1' max='100' value='" + treeData.quantity + "'/>";
		}else{
			type = 'sample';
			label = modelsData.sample_controls[treeData.control_id]["SampleControl"]["sample_type"];
		}

		if($(node)[0].nodeName != "UL"){
			if($(node).find("ul").length == 0){
				$(node).append('<ul></ul>');
			}
			node = $(node).find("ul:first");
		}
		$(node).append(
			'<li>' +
				'<div class="nodeBlock">' +
					'<div class="leftPart">- <a href="#" class="icon16 ' + type + '">&nbsp;</a></div>' +
					'<div class="rightPart">' + 
					addButton + '<a href="#" class="icon16 delete noPrompt">&nbsp;</a>' + 
					'<span class="nowrap">' + label + '</span></div>' +
				'</div>' +
			'</li>'
		);
		li = $(node).find("li:last");
		li.find(".leftPart a").css("cursor", "default");
		li.find("input").change(function(){
			if(numberValidation($(this), treeData.quantity)){
				$(this).parents('li:first').data("quantity", $(this).val());
				
			}
		});
		$(li).data({
			"datamart_structure_id" : treeData.datamart_structure_id, 
			"controlId" : Math.abs(treeData.control_id), 
			"nodeId" : treeData.id == 0 ? nodeId -- : treeData.id,
			"parent_id" : treeData.parent_id,
			"quantity" : treeData.quantity
		}); 
		bindButtons(li); 
		return li;
	}

	function getDropdownOptions(parent_id){
		var options = "";
		if(parent_id != ""){
			options += "<optgroup label='<?php echo __('derivative'); ?>'>";
		}
		for(i in modelsData.samples_relations[parent_id]){
			sample = modelsData.sample_controls[modelsData.samples_relations[parent_id][i]["ParentToDerivativeSampleControl"]["derivative_sample_control_id"]];
			options += "<option value='" + sample["SampleControl"]["id"] + "'>" + sample["SampleControl"]["sample_type"] + "</option>";
		}
		if(parent_id != ""){
			options += "</optgroup><optgroup label='<?php echo __('aliquot'); ?>'>";
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


	
	var currentNode = null;
	var templateInitId = null;
	function initWizardMode(wizard_id){
		//for each page
		//2 - re enable js controls (calendar, addline, suggest, data accuracy, etc.)
		$(".nameInput").remove();
		setLoading();
		$.get(root_url + 'InventoryManagement/Collections/templateInit/' + collectionId + '/' + wizard_id + "/noActions:/?t=" + new Date().getTime(), function(jsonData){
			jsonData = $.parseJSON(jsonData);
			$(".ajaxContent").html(jsonData.display);
			$(".ajaxContent form").append("<input type='hidden' name='data[0][bogus_hidden_for_submit]' value=''/>");
			globalInit(".ajaxContent");
			templateInitId = $("input[type=hidden][name=data\\\[template_init_id\\\]]").val();
		});

		$(document).delegate(".ajaxContent input[type=submit]", "click", overrideSubmitButton);
	}

	function setLoading(){
		$(".ajaxContent").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
		flyOverComponents();
	}

	function overrideSubmitButton(){
			$.post($("form").prop("action") + "/noActions:/", $("form").serialize(), function(jsonData){
				jsonData = $.parseJSON(jsonData);
				if(jsonData.goToNext){
					//update current node display if needed
					$(currentNode).data("id", jsonData.id);
					nextNode();
				}else{
					try{
						$(".ajaxContent").html(jsonData.display);
					}catch(e){
						//do nothing
					}
					addTemplateInitId();
					flyOverComponents();
					globalInit(".ajaxContent");
				}
			}); 
			setLoading();
			return false;
//		});
	}

	function nextNode(){
		setLoading();
		if(currentNode == null){
			//get first node
			currentNode = $(".tree_root li:first ul:first li:first:not(.wizardDone)");
		}else{
			currentNode.css("background-color", "#dfd");
			currentNode.find("div:first").css("font-weight", "normal");
			currentNode.find("a.delete:first").remove();
			if($(currentNode).find("li:not(.wizardDone)").length > 0){
				//going down
				currentNode = $(currentNode).find("li:not(.wizardDone)").first();
			}else{
				//goin up
				ul = $(currentNode).parents("ul:first");
				while(true){
					$(ul).find("li.wizardDone a.add").remove();
					if($(ul).hasClass("tree_root")){
						currentNode = null;
						break;
					}
					if($(ul).find("li:not(.wizardDone)").length > 0){
						currentNode = $(ul).find("li:not(.wizardDone)").first();
						break;
					}
					ul = $(ul).parents("ul:first");
				}
			}
		}
		if(currentNode && currentNode.length > 0){
			$(currentNode).addClass("wizardDone").css("background-color", "#ffc");
			$(currentNode).find("div:first").css("font-weight", "bold").find("input").attr("disabled", true);
			data = $(currentNode).data();
			url = null;
			if(data.datamart_structure_id == 1){
				//aliquot
				parentLi = $(currentNode).parents("li:first");
				url = 'InventoryManagement/AliquotMasters/add/' + $(parentLi).data("id") + '/' + data.controlId + '/' + data.quantity + '/';
			}else{
				//sample
				parentLi = $(currentNode).parents("li:first");
				parentLiData = $(parentLi).data();
				parentId = null;
				if(parentLiData.datamart_structure_id == 5){
					//parent is a sample
					parentId = parentLiData.id;
				}else{
					parentId = 0;
				}
				url = 'InventoryManagement/SampleMasters/add/<?php echo $collection_id; ?>/' + data.controlId + '/' + parentId + '/';
			}
			$.get(root_url + url + 'noActions:/', function(jsonData){
				jsonData = $.parseJSON(jsonData);
				try{
					$(".ajaxContent").html(jsonData.display);
				}catch(e){
					//do sweet nothing
				}
				flyOverComponents();
				globalInit(".ajaxContent");
				addTemplateInitId();
				if($("input[name=autosubmit]:checked").length == 1){
					$(".ajaxContent input[type=submit]").click();
				}
			});
		}else{
			//done
			$(".ajaxContent").html("<div class='center'><?php echo __('done'); ?><br/><?php echo __('redirecting to samples & aliquots'); ?></div>");
			$(".tree_root li:first").css("background-color", "#dfd");
			$(".tree_root a.add").remove();
			document.location = root_url + '/InventoryManagement/Collections/detail/' + collectionId;
		}
	}
	
	function confirmReset(){
		if($("#confirmReset").length == 0){
			buildConfirmDialog("confirmReset", "<?php echo __('are you sure you want to reset?'); ?>", new Array(
				{icon : "detail", label : STR_YES, "action" : function(){ document.location = root_url + "/Tools/Template/edit/<?php echo $template_id; ?>";}},
				{"icon" : "cancel", label : STR_CANCEL, "action" : function(){ $("#confirmReset").popup('close'); }})
			);
		}
		$("#confirmReset").popup();
	}

	function flashColor(item, color){
		var timer = 80;
		$(item).animate({
			"background-color": color
		  }, timer, function() {
		    // Animation complete.
			    $(item).animate({
					"background-color": "#fff"
				  }, timer, function() {
					  $(item).animate({
							"background-color": color
						  }, timer, function() {
							  $(item).animate({
									"background-color": "#fff"
								  }, timer);
						  });
				  });
		  });	
	}

	function addTemplateInitId(){
		$("form").append('<input type="hidden" name="data[template_init_id]" value="' + templateInitId + '"/>');
	}
</script>
