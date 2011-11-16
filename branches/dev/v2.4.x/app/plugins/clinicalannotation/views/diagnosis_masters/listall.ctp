<?php 
	
	$structure_links = array(
		'tree'=>array(
			'DiagnosisMaster' => array(
				'see diagnosis summary' => array(
					'link' => '/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
					'icon' => 'diagnosis'
				), 'access to all data' => array(
					'link' => '/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
					'icon' => 'access_to_data'
 				), 'add' => AppController::checkLinkPermission('/clinicalannotation/diagnosis_masters/add/') ? 'javascript:addPopup(%%DiagnosisMaster.id%%);' : '/noright'
			), 'TreatmentMaster' => array(
				'see treatment summary' => array(
					'link' => '/clinicalannotation/treatment_masters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/1',
					'icon' => 'treatments'
				), 'access to all data' => array(
					'link' => '/clinicalannotation/treatment_masters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/',
					'icon' => 'access_to_data'
 				)
			
			), 'EventMaster' => array(
				'see event summary' => array(
					'link' => '/clinicalannotation/event_masters/detail/clinical/%%EventMaster.participant_id%%/%%EventMaster.id%%/1',
					'icon' => 'annotation'
				), 'access to all data' => array(
					'link' => '/clinicalannotation/event_masters/detail/clinical/%%EventMaster.participant_id%%/%%EventMaster.id%%/',
					'icon' => 'access_to_data'
				)
			)
		),'ajax' => array(
			'index' => array(
				'see diagnosis summary' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				),
				'see treatment summary' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				),
				'see event summary' => array(
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
			if($diagnosis_control['DiagnosisControl']['category'] == 'primary'){
				$add_links[__($diagnosis_control['DiagnosisControl']['controls_type'], true)] = '/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/0/'.$diagnosis_control['DiagnosisControl']['id'].'/';
			}
		}
		ksort($add_links);
		$structure_links['bottom'] = array('add primary' => $add_links);
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
			), 'header' => array('title' => '', 'description' => sprintf(__('information about the diagnosis module is available %s here', true), $help_url))
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
			if($dx_ctrl['DiagnosisControl']['category'] != 'primary'){
				$options[$dx_ctrl['DiagnosisControl']['id']] = __($dx_ctrl['DiagnosisControl']['category'], true) . ' - ' .__($dx_ctrl['DiagnosisControl']['controls_type'], true);		
				if($dx_ctrl['DiagnosisControl']['category'] == 'secondary'){
					$secondary_ctrl_id = $dx_ctrl['DiagnosisControl']['id'];
				}
			}
		}
		
		$hook_link = $structures->hook('after_ids_groups');
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
		var loadingStr = "<?php echo(__("loading", null)); ?>";
		var ajaxTreeView = true;
		var canHaveChild = [<?php echo implode(", ", $can_have_child); ?>];
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
						if($(parentUl).hasClass("tree_root")){
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
		
		<?php  
	}