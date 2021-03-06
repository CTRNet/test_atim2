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
if (isset($overflow)) {
    ?>
<ul class="error">
	<li><?php echo(__("the query returned too many results").". ".__("try refining the search parameters")); ?>.</li>
</ul>
<?php
}
$header = array(
    'title' => __('icd10 code picker'),
    'description' => __('select an icd10 code')
);
$indexLinkPrefix = "/CodingIcd/CodingIcd10s/search/";
$links = array(
    'index' => array(
        'detail' => $indexLinkPrefix . '%%CodingIcd.id%%'
    ),
    'bottom' => array(
        'back' => '/CodingIcd/CodingIcd10s/tool/' . $useIcdType
    )
);
$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'settings' => array(
        'pagination' => false,
        'header' => $header
    ),
    'links' => $links
));
?>
<script type="text/javascript">
$(function(){
	$("#default_popup a.detail").click(function(){
		val = $(this).attr("href");
		indexLinkPrefix = "<?php echo($indexLinkPrefix); ?>";
		val = val.substr(val.indexOf(indexLinkPrefix) + indexLinkPrefix.length);
		$(toolTarget).val(val);
		$("#default_popup").popup('close');
		return false;
	});
	$("#default_popup a.cancel").click(function(){
		$.get($(this).attr("href"), null, function(data){
                    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        saveSqlLogAjax(ajaxSqlLog);
                    }
			$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
			$("#default_popup input[type=text]").first().focus();
		});
		return false;
	});
	$("#default_popup div.search-result-div").hide();
});
</script>