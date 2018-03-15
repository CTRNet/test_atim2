<div id="me">
<?php
$type = $useIcdType == "topo" ? "topography" : "morphology";
$this->Structures->build($atimStructure, array(
    'type' => 'search',
    'links' => array(
        'top' => 'foo'
    ),
    'settings' => array(
        'header' => __('search for an icdo3 ' . $type . ' code'),
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
	$.post(root_url + "CodingIcd/CodingIcdo3s/search/<?php echo($useIcdType); ?>/1", $("#me form").serialize(), function(data){
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