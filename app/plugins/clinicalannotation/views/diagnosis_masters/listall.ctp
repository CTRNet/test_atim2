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
 				)
			), 'TreatmentMaster' => array(
				'detail' => array(
					'link' => '/clinicalannotation/treatment_masters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/',
					'icon' => 'treatments'
				), 'access to all data' => array(
					'link' => '/clinicalannotation/treatment_masters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/',
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
		$structure_links['tree']['DiagnosisMaster']['add'] = AppController::checkLinkPermission('/clinicalannotation/diagnosis_masters/add/') ? 'javascript:addPopup(%%DiagnosisMaster.id%%);' : '/noright';
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
		?>
		<script>
		var loadingStr = "<?php echo(__("loading", null)); ?>";
		var ajaxTreeView = true;

		function addPopup(diagnosis_master_id){
			if($("#addPopup").length == 0){
				buildDialog("addPopup", "Select a type to add", "<div id='target'></div>", new Array(
					{"label" : STR_CANCEL, "icon" : "cancel", "action" : function(){ $("#addPopup").popup("close"); }}, 
					{ "label" : STR_OK, "icon" : "add", "action" : function(){ document.location = root_url + 'clinicalannotation/diagnosis_masters/add/<?php echo $atim_menu_variables['Participant.id'] ; ?>/' + $("#addPopup").data("dx_id") + '/' + $("#addPopup select").val() + '/' } }));
				$("#popupSelect").appendTo("#target").show();
			}
			$("#addPopup").data("dx_id", diagnosis_master_id).popup();
		}
		</script>
		<div id="popupSelect" class="hidden">
			<?php
			$options = array();
			foreach($diagnosis_controls_list as $dx_ctrl){
				if($dx_ctrl['DiagnosisControl']['flag_secondary']){
					$options[$dx_ctrl['DiagnosisControl']['id']] = __($dx_ctrl['DiagnosisControl']['databrowser_label'], true);
				}	
			}
			echo $this->Form->input("data[DiagnosisControl][id]", array('type' => 'select', 'label' => false, 'options' => $options)); 
			?>
		</div>
		<?php  
	}