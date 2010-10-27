<div id="me">
<?php 
$this->Structures->build($atim_structure, array('type' => 'search', 'links' => array('top' => 'foo'), 
	'settings' => array('header' => __('search for an icd10 code', true), 'actions' => false)));
?>
<div id="results">

</div>
<?php 
$this->Structures->build($empty, array('settings' => array('top' => false)));
?>
</div>
<script type="text/javascript">
var popupSearch = function(){
	$.post(root_url + "codingicd/CodingIcd10s/search/<?php echo($use_icd_type); ?>/1", $("#me form").serialize(), function(data){
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