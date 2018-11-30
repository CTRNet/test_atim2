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

?>
<div id="me">
<?php
$this->Structures->build($atimStructure, array(
    'type' => 'search',
    'links' => array(
        'top' => '/'
    ),
    'settings' => array(
        'header' => __('search for an icd10 code'),
        'actions' => false
    )
));
?>
<div id="results"></div>
<?php
$this->Structures->build($empty, array(
    'type' => 'search',
    'settings' => array(
        'form_top' => false
    )
));
?>
</div>
<script type="text/javascript">
var popupSearch = function(){
	$.post(root_url + "CodingIcd/CodingIcd10s/search/<?php echo($useIcdType); ?>/1", $("#me form").serialize(), function(data){
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }
            
		$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
	});
	return false;
};

$(function(){
	$("#me .adv_ctrl").hide();
	$("#me .form.search").unbind('click').attr("onclick", null).click(popupSearch);
	$("#me form").submit(popupSearch);
	$("#me div.search-result-div").hide();
});

</script>