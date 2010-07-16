<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

	<?php
		$header = $shell->header( array('atim_menu_for_header'=>$atim_menu_for_header,'atim_menu'=>$atim_menu,'atim_menu_variables'=>$atim_menu_variables) );
		$title = $this->loaded['shell']->pageTitle;
		
	?>
	
	<title><?php echo $title.' &laquo; '.__('core_appname', true); ?></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="shortcut icon" href="<?php echo($this->webroot); ?>/img/favicon.ico"/>
	<?php 
		echo $html->css('style')."\n"; 
		echo $html->css('jQuery/themes/ui-lightness/jquery-ui-1.8.custom')."\n"; 
		echo $html->css('jQuery/themes/jquery_cupertino/jquery-ui-1.8.custom')."\n"; 
//		echo $html->css('datepicker')."\n";
//		echo $html->css('lightwindow')."\n";

		//set the locale
		if(__('clin_english', true) == "Anglais"){
			$locale = "fr";
		}else{
			$locale = "";
		}
		?>
		<script type="text/javascript">
		var root_url = "<?php echo($this->webroot); ?>";
		var webroot_dir = root_url + "/app/webroot/";
		var locale = "<?php echo($locale); ?>";
		var STR_OR = "<?php __('or'); ?>";
		var STR_SPECIFIC = "<?php __('specific'); ?>";
		var STR_RANGE = "<?php __('range'); ?>";
		var STR_TO = "<?php __('to'); ?>";
		</script>
		<?php
		echo $javascript->link('jquery-1.4.2.min')."\n";
		echo $javascript->link('jquery-ui-1.8.custom.min')."\n";
		echo $javascript->link('jquery.ui-datepicker-fr.js')."\n";
		echo $javascript->link('jquery.highlight.js')."\n";
//		echo $javascript->link('datepicker')."\n";
//		echo $javascript->link('prototype')."\n";
//		echo $javascript->link('scriptaculous.js?load=effects,dragdrop')."\n";
//		echo $javascript->link('lightwindow')."\n";
		echo $javascript->link('default')."\n";
//		echo $javascript->link('controls')."\n";
	?>
	<!--[if IE 7]>
	<?php
		echo $html->css('iehacks');
	?>
	<![endif]-->
</head>
<body>
	
<?php 
	echo $header;
	
	// $session->flash();
	$session->flash('auth');
	
	echo $content_for_layout;
	
	echo $shell->footer();

	echo $this->element('sql_dump');
?>
	
	<script type="text/javascript">
	$(function(){
		initJsControls();
	});
	</script>
</body>
</html>