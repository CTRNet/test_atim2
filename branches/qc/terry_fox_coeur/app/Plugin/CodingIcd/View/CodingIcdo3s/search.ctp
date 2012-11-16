<?php 
if(isset($overflow)){
	?>
	<ul class="error">
		<li><?php echo(__("the query returned too many results").". ".__("try refining the search parameters")); ?>.</li>
	</ul>
	<?php 
}
$type = $use_icd_type == "topo" ? "topography" : "morphology";
$header = array('title' => __('icdo3 '.$type.' code picker'), 'description' => __('select an icdo3 '.$type.' code'));
$index_link_prefix = "/CodingIcd/CodingIcdo3s/search/";
$links = array(
	'index' => array('detail' => $index_link_prefix.'%%CodingIcd.id%%'),
	'bottom' => array('back' => '/CodingIcd/CodingIcdo3s/tool/'.$use_icd_type));
$this->Structures->build($atim_structure, array('type' => 'index', 'settings' => array('pagination' => false, 'header' => $header), 'links' => $links));
?>
<script type="text/javascript">
$(function(){
	$("#default_popup a.detail").click(function(){
		val = $(this).attr("href");
		indexLinkPrefix = "<?php echo($index_link_prefix); ?>";
		val = val.substr(val.indexOf(indexLinkPrefix) + indexLinkPrefix.length);
		$(toolTarget).val(val);
		$("#default_popup").popup('close');
		return false;
	});
	$("#default_popup a.cancel").click(function(){
		$.get($(this).attr("href"), null, function(data){
			$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
			$("#default_popup input[type=text]").first().focus();
		});
		return false;
	});
	$("#default_popup div.search-result-div").hide();
});
</script>