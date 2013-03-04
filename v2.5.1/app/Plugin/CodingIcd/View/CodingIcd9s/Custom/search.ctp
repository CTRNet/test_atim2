<?php 
if(isset($overflow)){
	?>
	<ul class="error">
		<li><?php echo(__("the query returned too many results").". ".__("try refining the search parameters")); ?>.</li>
	</ul>
	<?php 
}
$header = array('title' => __('icd9 code picker'), 'description' => __('select an icd9 code'));
$index_link_prefix = "/CodingIcd/CodingIcd9s/search/";
$links = array(
	'index' => array('detail' => $index_link_prefix.'%%CodingIcd.id%%'),
	'bottom' => array('back' => '/CodingIcd/CodingIcd9s/tool/'.$use_icd_type));
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