<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
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