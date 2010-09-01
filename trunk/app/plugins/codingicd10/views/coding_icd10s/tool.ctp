<div id="me">
<?php 
$this->Structures->build($atim_structure, array('type' => 'search', 'links' => array('top' => 'foo'), 'settings' => array('header' => 'Search for an icd10 code', 'actions' => false)));
?>
<div id="results">

</div>
<?php 
$this->Structures->build($empty, array('settings' => array('top' => false)));
?>
</div>
<script type="text/javascript">
var popupSearch = function(){
	$.post(root_url + "/codingicd10/CodingIcd10s/search/1", $("#me form").serialize(), function(data){
		$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
	});
	return false;
};

$(function(){
	$("#me .adv_ctrl").hide();
	$("#me .form.search").unbind('click').attr("onclick", null).click(popupSearch);
	$("#me form").submit(popupSearch);
});

</script>