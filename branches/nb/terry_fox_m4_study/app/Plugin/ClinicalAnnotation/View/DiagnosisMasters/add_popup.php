<?php
$options = array();
$secondaryCtrlId = array();
AppController::$highlightMissingTranslations = false;
if (AppController::checkLinkPermission('ClinicalAnnotation/DiagnosisMasters/add/')) {
    $current = array();
    foreach ($diagnosisControlsList as $dxCtrl) {
        if ($dxCtrl['DiagnosisControl']['category'] != 'primary') {
            $current[$dxCtrl['DiagnosisControl']['id']] = __($dxCtrl['DiagnosisControl']['category']) . ' - ' . __($dxCtrl['DiagnosisControl']['controls_type']);
            if ($dxCtrl['DiagnosisControl']['category'] == 'secondary - distant') {
                $secondaryCtrlId[] = $dxCtrl['DiagnosisControl']['id'];
            }
        }
    }
    natcasesort($current);
    $options[] = array(
        'grpName' => __('diagnosis'),
        'data' => $current,
        'link' => 'ClinicalAnnotation/DiagnosisMasters/add/' . $atimMenuVariables['Participant.id'] . '/'
    );
}
if (AppController::checkLinkPermission('ClinicalAnnotation/TreatmentMasters/add/')) {
    $current = array();
    foreach ($treatmentControlsList as $txCtrl) {
        $current[$txCtrl['TreatmentControl']['id']] = __($txCtrl['TreatmentControl']['tx_method']) . (empty($txCtrl['TreatmentControl']['disease_site']) ? '' : ' - ' . __($txCtrl['TreatmentControl']['disease_site']));
    }
    natcasesort($current);
    $options[] = array(
        'grpName' => __('treatment'),
        'data' => $current,
        'link' => 'ClinicalAnnotation/TreatmentMasters/add/' . $atimMenuVariables['Participant.id'] . '/'
    );
}
if (AppController::checkLinkPermission('ClinicalAnnotation/EventMasters/add/')) {
    $current = array();
    foreach ($eventControlsList as $eventCtrl) {
        $current[$eventCtrl['EventControl']['event_group']][$eventCtrl['EventControl']['id']] = __($eventCtrl['EventControl']['event_type']) . (empty($eventCtrl['EventControl']['disease_site']) ? '' : ' - ' . __($eventCtrl['EventControl']['disease_site']));
    }
    ksort($current);
    foreach ($current as $groupName => $grpOptions) {
        natcasesort($grpOptions);
        $options[] = array(
            'grpName' => __('event') . ' - ' . __($groupName),
            'data' => $grpOptions,
            'link' => 'ClinicalAnnotation/EventMasters/add/' . $atimMenuVariables['Participant.id'] . '/'
        );
    }
}
AppController::$highlightMissingTranslations = true;

$hookLink = $this->Structures->hook('after_ids_groups');
if ($hookLink) {
    require ($hookLink);
}
?>
<div id="popupSelect" class="hidden">
			<?php
echo $this->Form->input("data[DiagnosisControl][id]", array(
    'type' => 'select',
    'label' => false,
    'options' => array()
));
?>
		</div>
<script>
		var canHaveChild = [<?php echo implode(", ", $canHaveChild); ?>];
		var dropdownOptions = "<?php echo addslashes(json_encode($options)); ?>";
		var secondaryCtrlId = [<?php echo implode(", ", $secondaryCtrlId); ?>];

		function addPopup(diagnosisMasterId, diagnosisControlId){
			if($("#addPopup").length == 0){
				buildDialog("addPopup", "Select a type to add", "<div id='target'></div>", new Array(
					{"label" : STR_CANCEL, "icon" : "cancel", "action" : function(){ $("#addPopup").popup("close"); }}, 
					{ "label" : STR_OK, "icon" : "add", "action" : function(){ document.location = root_url + $("#addPopup select").val() + '/' + $("#addPopup").data("dx_id"); } }));
				$("#popupSelect").appendTo("#target").show();
			}

			var options = "";
			if($.inArray(diagnosisControlId, secondaryCtrlId) != -1){
				for(i in dropdownOptions){
					options += "<optgroup label='" + dropdownOptions[i].grpName + "'>";
					for(j in dropdownOptions[i].data){
						if(i > 0 || $.inArray(parseInt(j), secondaryCtrlId) == -1){
							options += "<option value='" + dropdownOptions[i].link + j + "'>" + dropdownOptions[i].data[j] + "</option>";
						}
					}
					options += "</optgroup>";
				}
			}else{
				for(i in dropdownOptions){
					if(i == 0 && $.inArray(diagnosisMasterId, canHaveChild) == -1){
						continue;
					}
					options += "<optgroup label='" + dropdownOptions[i].grpName + "'>";
					for(j in dropdownOptions[i].data){
						options += "<option value='" + dropdownOptions[i].link + j + "'>" + dropdownOptions[i].data[j] + "</option>";
					}
					options += "</optgroup>";
				}
			}
			$("#data\\[DiagnosisControl\\]\\[id\\]").html(options);
			$("#addPopup").data("dx_id", diagnosisMasterId).popup();
		}

		function initTree(section){
			$("a.add").each(function(){
				if($(this).prop("href").indexOf("javascript:addPopup(") == 0){
					//remove add button for "unknown" nodes
					var id = $(this).prop("href").substr(20, $(this).prop("href").length - 22);
					if($.inArray(parseInt(id), canHaveChild) == -1){
						//$(this).hide();
					}
				}
			});
		}

		function initPage(){
			dropdownOptions = $.parseJSON(dropdownOptions);
			initTree($("body"));
		}
</script>