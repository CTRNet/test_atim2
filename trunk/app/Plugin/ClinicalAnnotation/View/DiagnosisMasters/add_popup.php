<?php
$options = array();
$secondary_ctrl_id = 0;
AppController::$highlight_missing_translations = false;
if(AppController::checkLinkPermission('ClinicalAnnotation/DiagnosisMasters/add/')){
	$current = array();
	foreach($diagnosis_controls_list as $dx_ctrl){
		if($dx_ctrl['DiagnosisControl']['category'] != 'primary'){
			$current[$dx_ctrl['DiagnosisControl']['id']] = __($dx_ctrl['DiagnosisControl']['category']) . ' - ' .__($dx_ctrl['DiagnosisControl']['controls_type']);
			if($dx_ctrl['DiagnosisControl']['category'] == 'secondary'){
				$secondary_ctrl_id = $dx_ctrl['DiagnosisControl']['id'];
			}
		}
	}
	$options[] = array('grpName' => __('diagnosis'), 'data' => $current, 'link' => 'ClinicalAnnotation/DiagnosisMasters/add/'.$atim_menu_variables['Participant.id'].'/');
}
if(AppController::checkLinkPermission('ClinicalAnnotation/TreatmentMasters/add/')){
	$current = array();
	foreach($treatment_controls_list as $tx_ctrl){
		$current[$tx_ctrl['TreatmentControl']['id']] = __($tx_ctrl['TreatmentControl']['tx_method']);
	}
	$options[] = array('grpName' => __('treatment'), 'data' => $current, 'link' => 'ClinicalAnnotation/TreatmentMasters/add/'.$atim_menu_variables['Participant.id'].'/');
}
if(AppController::checkLinkPermission('ClinicalAnnotation/EventMasters/add/')){
	$current = array();
	foreach($event_controls_list as $event_ctrl){
		$current[$event_ctrl['EventControl']['event_group']][$event_ctrl['EventControl']['id']] = __($event_ctrl['EventControl']['event_type']);
	}
	foreach($current as $group_name => $grp_options){
		$options[] = array('grpName' => __('event').' - '.__($group_name), 'data' => $grp_options, 'link' => 'ClinicalAnnotation/EventMasters/add/'.$group_name.'/'.$atim_menu_variables['Participant.id'].'/');
	}
}
AppController::$highlight_missing_translations = true;

$hook_link = $this->Structures->hook('after_ids_groups');
if( $hook_link ) {
	require($hook_link);
}

?>
		<div id="popupSelect" class="hidden">
			<?php
			echo $this->Form->input("data[DiagnosisControl][id]", array('type' => 'select', 'label' => false, 'options' => array())); 
			?>
		</div>
		
		
		<script>
		var canHaveChild = [<?php echo implode(", ", $can_have_child); ?>];
		var dropdownOptions = "<?php echo addslashes(json_encode($options)); ?>";
		var secondaryCtrlId = <?php echo $secondary_ctrl_id; ?>;

		function addPopup(diagnosis_master_id, isSecondary){
			if($("#addPopup").length == 0){
				buildDialog("addPopup", "Select a type to add", "<div id='target'></div>", new Array(
					{"label" : STR_CANCEL, "icon" : "cancel", "action" : function(){ $("#addPopup").popup("close"); }}, 
					{ "label" : STR_OK, "icon" : "add", "action" : function(){ document.location = root_url + $("#addPopup select").val() + '/' + $("#addPopup").data("dx_id"); } }));
				$("#popupSelect").appendTo("#target").show();
			}

			$("a.icon16.add, .bottom_button a.add").each(function(){
				if($(this).prop("href").indexOf("javascript:addPopup(") == 0){
					//remove add button for "unknown" nodes
					if(parseInt($(this).prop("href").substr(20, $(this).prop("href").length - 22)) == diagnosis_master_id){
						//found the right one
						var options = "";
						if(isSecondary == undefined){
							isSecondary = $(this).parents("ul:first").hasClass("tree_root");
						}
						if(isSecondary){
							//options without secondary
							for(i in dropdownOptions){
								options += "<optgroup label='" + dropdownOptions[i].grpName + "'>";
								for(j in dropdownOptions[i].data){
									if(i > 0 || j != secondaryCtrlId){
										options += "<option value='" + dropdownOptions[i].link + j + "'>" + dropdownOptions[i].data[j] + "</option>";
									}
								}
								options += "</optgroup>";
							}
						}else{
							//full options dropdown
							for(i in dropdownOptions){
								options += "<optgroup label='" + dropdownOptions[i].grpName + "'>";
								for(j in dropdownOptions[i].data){
									options += "<option value='" + dropdownOptions[i].link + j + "'>" + dropdownOptions[i].data[j] + "</option>";
								}
								options += "</optgroup>";
							}
						}
						$("#data\\[DiagnosisControl\\]\\[id\\]").html(options);
					}
				}
			});
			
			$("#addPopup").data("dx_id", diagnosis_master_id).popup();
		}

		function initTree(section){
			$("a.form.add").each(function(){
				if($(this).prop("href").indexOf("javascript:addPopup(") == 0){
					//remove add button for "unknown" nodes
					var id = $(this).prop("href").substr(20, $(this).prop("href").length - 22);
					if($.inArray(parseInt(id), canHaveChild) == -1){
						$(this).hide();
					}
				}
			});
		}

		function initPage(){
			dropdownOptions = $.parseJSON(dropdownOptions);
			initTree($("body"));
		}
		</script>
