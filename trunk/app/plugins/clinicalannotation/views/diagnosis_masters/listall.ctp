<?php 
	
	$structure_links = array(
		'tree'=>array(
			'DiagnosisMaster' => array(
				'detail' => array(
					'link' => '/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
					'icon' => 'diagnosis'
				), 'access to all data' => array(
					'link' => '/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
					'icon' => 'access_to_data'
 				), 'add' => AppController::checkLinkPermission('/clinicalannotation/diagnosis_masters/add/') ? 'javascript:addPopup(%%DiagnosisMaster.id%%);' : '/noright'
			), 'TreatmentMaster' => array(
				'detail' => array(
					'link' => '/clinicalannotation/treatment_masters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/1',
					'icon' => 'treatments'
				), 'access to all data' => array(
					'link' => '/clinicalannotation/treatment_masters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/',
					'icon' => 'access_to_data'
 				)
			
			), 'EventMaster' => array(
				'detail' => array(
					'link' => '/clinicalannotation/event_masters/detail/clinical/%%EventMaster.participant_id%%/%%EventMaster.id%%/1',
					'icon' => 'annotation'
				), 'access to all data' => array(
					'link' => '/clinicalannotation/event_masters/detail/clinical/%%EventMaster.participant_id%%/%%EventMaster.id%%/',
					'icon' => 'access_to_data'
				)
			)
		),'ajax' => array(
			'index' => array(
				'detail' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				)
			)
		),'tree_expand' => array(
			'DiagnosisMaster' => '/clinicalannotation/diagnosis_masters/listall/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/1',
		)
	);
	
	if(!$is_ajax){
		$add_links = array();
		foreach ($diagnosis_controls_list as $diagnosis_control){
			if($diagnosis_control['DiagnosisControl']['flag_primary']){
				$add_links[__($diagnosis_control['DiagnosisControl']['controls_type'], true)] = '/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/0/'.$diagnosis_control['DiagnosisControl']['id'].'/';
			}
		}
		ksort($add_links);
		$structure_links['bottom'] = array('add' => $add_links);
	}
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure;
	$final_options = array(
		'type' => 'tree',
		'links' => $structure_links,
		'extras' => $structure_extras,
		'settings' => array(
			'tree'=>array(
				'DiagnosisMaster' => 'DiagnosisMaster',
				'TreatmentMaster' => 'TreatmentMaster',
				'EventMaster' => 'EventMaster',
			)
		)
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	if(!$is_ajax){
		$options = array();
		$secondary_ctrl_id = null;
		foreach($diagnosis_controls_list as $dx_ctrl){
			if($dx_ctrl['DiagnosisControl']['flag_secondary']){
				$options[$dx_ctrl['DiagnosisControl']['id']] = __($dx_ctrl['DiagnosisControl']['databrowser_label'], true);
				if($dx_ctrl['DiagnosisControl']['controls_type'] == 'secondary'){
					$secondary_ctrl_id = $dx_ctrl['DiagnosisControl']['id'];
				}
			}
		}
		?>
		<div id="popupSelect" class="hidden">
			<?php
			echo $this->Form->input("data[DiagnosisControl][id]", array('type' => 'select', 'label' => false, 'options' => array())); 
			?>
		</div>
		
		
		<script>
		var loadingStr = "<?php echo(__("loading", null)); ?>";
		var ajaxTreeView = true;
		var noAddIds = [<?php echo implode(", ", $no_add_ids); ?>];
		var dropdownOptions = "<?php echo addslashes(json_encode($options)); ?>";
		var secondaryCtrlId = <?php echo $secondary_ctrl_id; ?>;

		function addPopup(diagnosis_master_id){
			if($("#addPopup").length == 0){
				buildDialog("addPopup", "Select a type to add", "<div id='target'></div>", new Array(
					{"label" : STR_CANCEL, "icon" : "cancel", "action" : function(){ $("#addPopup").popup("close"); }}, 
					{ "label" : STR_OK, "icon" : "add", "action" : function(){ document.location = root_url + 'clinicalannotation/diagnosis_masters/add/<?php echo $atim_menu_variables['Participant.id'] ; ?>/' + $("#addPopup").data("dx_id") + '/' + $("#addPopup select").val() + '/' } }));
				$("#popupSelect").appendTo("#target").show();
			}

			$("a.form.add").each(function(){
				if($(this).prop("href").indexOf("javascript:addPopup(") == 0){
					//remove add button for "unknown" nodes
					if(parseInt($(this).prop("href").substr(20, $(this).prop("href").length - 22)) == diagnosis_master_id){
						//found the right one
						var parentUl = getParentElement(this, "UL");
						var options = "";
						if($(parentUl).prop("id") == "tree_root"){
							//full options dropdown
							for(i in dropdownOptions){
								options += "<option value='" + i + "'>" + dropdownOptions[i] + "</option>";
							}
						}else{
							//options without secondary
							for(i in dropdownOptions){
								if(i != secondaryCtrlId){
									options += "<option value='" + i + "'>" + dropdownOptions[i] + "</option>";
								}
							}
						}
						$("#data\\[DiagnosisControl\\]\\[id\\]").html(options);
					}
				}
			});
			
			$("#addPopup").data("dx_id", diagnosis_master_id).popup();
		}

		function initPage(){
			$("a.form.add").each(function(){
				if($(this).prop("href").indexOf("javascript:addPopup(") == 0){
					//remove add button for "unknown" nodes
					var id = $(this).prop("href").substr(20, $(this).prop("href").length - 22);
					if($.inArray(parseInt(id), noAddIds) > -1){
						$(this).hide();
					}
				}
			});

			dropdownOptions = $.parseJSON(dropdownOptions);
		}
		</script>
		
		<?php  
	}