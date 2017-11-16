<?php
$treeHtml = '<table class="structure">
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
$finalOptions = array();
if ($controls) {
    $finalOptions = array(
        'type' => 'edit',
        'links' => array(
            'top' => '/Tools/Template/edit/' . $templateId,
            'bottom' => array(
                'reset' => array(
                    'link' => 'javascript:confirmReset();',
                    'icon' => 'redo'
                )
            )
        ),
        'settings' => array(
            'return' => true,
            'form_bottom' => true
        ),
        'extras' => $treeHtml
    );
    if ($editProperties) {
        $finalOptions['links']['bottom']['edit properties'] = '/Tools/Template/editProperties/' . $templateId;
        $finalOptions['links']['bottom']['delete'] = '/Tools/Template/delete/' . $templateId;
    }
    if (isset($isAjax)) {
        $finalOptions['settings']['actions'] = false;
    }
} else {
    $finalOptions = array(
        'type' => 'detail',
        'extras' => "<div style='padding-left: 10px;'><label>" . __('auto submit') . "</label><input type='checkbox' name='autosubmit'/></div>" . $treeHtml . "<div class='ajaxContent'></div>",
        'settings' => array(
            'return' => true
        )
    );
    if (isset($structureHeader)) {
        $finalOptions['settings']['header'] = $structureHeader;
    }
}

$finalAtimStructure = $atimStructure;
$page = $this->Structures->build($finalAtimStructure, $finalOptions);

if (isset($isAjax)) {
    $page = $this->Shell->validationHtml() . $page;
    $tmp = $this->Shell->validationErrors();
    $hasErrors = ! empty($tmp);
    $this->validationErrors = array();
    $this->layout = 'json';
    $this->json = array(
        'page' => $page,
        'has_errors' => $hasErrors
    );
    return;
} else {
    echo $page;
}

?>

<script>
	var STR_ADD = "<?php echo __('add'); ?>";
	var modelsData = '<?php echo addslashes(json_encode($jsData)); ?>';
	var wizardTreeData = '<?php  echo Inflector::variable(json_encode($treeData)); ?>';
	var nodeId = 0;
	var collectionId = <?php echo isset($collectionId) ? $collectionId : null; ?>;

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
				saveSqlLogAjax(data);
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
			initWizardMode(<?php echo $templateId; ?>);
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
								data.datamartStructureId = $("#addDialog select").val() > 0 ? 5 : 1;
								data.children = new Array();
								data.controlId = $("#addDialog select").val();
								data.label =  $("#addDialog select option[value='" + data.controlId + "']").text();
								data.id = 0;
								data.parentId = typeof $("#addDialog").data("parentId")==='undefined'?"undefined":$("#addDialog").data("parentId");
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
			if($(li).data("datamartStructureId") == 2){
				options = getDropdownOptions("");
			}else if($(li).data("datamartStructureId") == 5){
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
			$("#addDialog").data("parentId", typeof $(liParent).data("nodeId")==='undefined'?"undefined":$(liParent).data("nodeId"));
			updateNumInput();
			$("#addDialog").popup();
			return false;
		});
	}
	
	function addNode(treeData, node){
		addButton = treeData.datamartStructureId != 1 && <?php echo isset($flagSystem) && $flagSystem ? 'false' : 'true' ?> ? '<a href="#" class="icon16 add">&nbsp;</a>' : '';
		type = null;
		label = null;
		if(treeData.datamartStructureId == 2){
			label = '<?php echo __('collection'); ?>';
			type = 'collection';
		}else if(treeData.datamartStructureId == 1){
			type = 'aliquot';
			label = modelsData.aliquot_controls[Math.abs(treeData.controlId)]["AliquotControl"]["aliquot_type"] + " <input type='number' size='1' min='1' max='100' value='" + treeData.quantity + "'/>";
		}else{
			type = 'sample';
			label = modelsData.sample_controls[treeData.controlId]["SampleControl"]["sample_type"];
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
			"datamartStructureId" : treeData.datamartStructureId, 
			"controlId" : Math.abs(treeData.controlId), 
			"nodeId" : treeData.id === 0 ? nodeId -- : treeData.id,
			"parentId" : treeData.parentId,
			"quantity" : treeData.quantity
		}); 
		bindButtons(li); 
		return li;
	}

	function getDropdownOptions(parentId){
		var options = "";
		if(parentId != ""){
			options += "<optgroup label='<?php echo __('derivative'); ?>'>";
		}
		for(i in modelsData.samples_relations[parentId]){
			sample = modelsData.sample_controls[modelsData.samples_relations[parentId][i]["ParentToDerivativeSampleControl"]["derivative_sample_control_id"]];
			options += "<option value='" + sample["SampleControl"]["id"] + "'>" + sample["SampleControl"]["sample_type"] + "</option>";
		}
		if(parentId != ""){
			options += "</optgroup><optgroup label='<?php echo __('aliquot'); ?>'>";
		}
		for(i in modelsData.aliquot_relations[parentId]){
			aliquot = modelsData.aliquot_relations[parentId][i];
			options += "<option value='" + (-1 * aliquot["AliquotControl"]["id"]) + "'>" + aliquot["AliquotControl"]["aliquot_type"] + "</option>";
		}
		if(parentId != ""){
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
			saveSqlLogAjax(jsonData);
			$(".ajaxContent").html(jsonData.page);
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
		$.post($("form").prop("action") + "/noActions:/templateInitId:" + templateInitId + '/', $("form").serialize(), function(jsonData){
			jsonData = $.parseJSON(jsonData);
			saveSqlLogAjax(jsonData);
			if(jsonData.goToNext){
				//update current node display if needed
				$(currentNode).data("id", jsonData.id);
				nextNode();
			}else{
				try{
					$(".ajaxContent").html(jsonData.page);
				}catch(e){
					//do nothing
				}
				flyOverComponents();
				globalInit(".ajaxContent");
			}
		}); 
		setLoading();
		return false;
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
			if(data.datamartStructureId == 1){
				//aliquot
				parentLi = $(currentNode).parents("li:first");
				url = 'InventoryManagement/AliquotMasters/add/' + $(parentLi).data("id") + '/' + data.controlId + '/' + data.quantity + '/';
			}else{
				//sample
				parentLi = $(currentNode).parents("li:first");
				parentLiData = $(parentLi).data();
				parentId = null;
				if(parentLiData.datamartStructureId == 5){
					//parent is a sample
					parentId = parentLiData.id;
				}else{
					parentId = 0;
				}
				url = 'InventoryManagement/SampleMasters/add/<?php echo $collectionId; ?>/' + data.controlId + '/' + parentId + '/';
			}

			$.get(root_url + url + 'noActions:/templateInitId:' + templateInitId + '/', function(jsonData){
				jsonData = $.parseJSON(jsonData);
				saveSqlLogAjax(jsonData);
				try{
					$(".ajaxContent").html(jsonData.page);
				}catch(e){
					//do sweet nothing
				}
				flyOverComponents();
				globalInit(".ajaxContent");
				if($("input[name=autosubmit]:checked").length == 1){
					$(".ajaxContent input[type=submit]").click();
				}
			});
		}else{
			//done
			$(".ajaxContent").html("<div class='center'><?php echo __('done'); ?><br/><?php echo __('redirecting to samples & aliquots'); ?></div>");
			$(".tree_root li:first").css("background-color", "#dfd");
			$(".tree_root a.add").remove();
			document.location = root_url + 'InventoryManagement/Collections/detail/' + collectionId;
		}
	}
	
	function confirmReset(){
		if($("#confirmReset").length == 0){
			buildConfirmDialog("confirmReset", "<?php echo __('are you sure you want to reset?'); ?>", new Array(
				{icon : "detail", label : STR_YES, "action" : function(){ document.location = root_url + "/Tools/Template/edit/<?php echo $templateId; ?>";}},
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
</script>