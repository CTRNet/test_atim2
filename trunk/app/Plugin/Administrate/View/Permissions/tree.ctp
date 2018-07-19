<?php
// ATiM tree
$structureLinks = array(
    'top' => '/Administrate/Permissions/tree/' . join('/', array_filter($atimMenuVariables))
);
$description = __("you can find help about permissions %s");
$description = sprintf($description, $helpUrl);

$structureExtras = array();
$structureExtras[10] = '<div id="frame"></div>';

$this->Structures->build($permissions2, array(
    "type" => "edit",
    "data" => $groupData,
    'links' => $structureLinks,
    "settings" => array(
        "form_bottom" => false,
        'actions' => false,
        'header' => array(
            'title' => __('permissions control panel'),
            'description' => $description
        )
    )
));

$this->Structures->build(array(
    "Aco" => $atimStructure
), array(
    'data' => $this->request->data,
    'type' => 'tree',
    'links' => $structureLinks,
    'extras' => $structureExtras,
    'settings' => array(
        'form_top' => false,
        'tree' => array(
            'Aco' => 'Aco'
        )
    )
));
?>
<script>
	var treeView = true;
	var permissionPreset = <?php echo AppController::checkLinkPermission('/Administrate/Permissions/loadPreset/') ? "true" : "false" ?>;

	function loadPresetFrame(){
		$("#frame").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
		$.get(root_url + "Administrate/Permissions/loadPreset/", null, function(data){
                    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        saveSqlLogAjax(ajaxSqlLog);
                    }
                    
                    $("#frame").html(data);
		});
	}
</script>