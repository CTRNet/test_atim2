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
		echo $html->css('jQuery/themes/custom-theme/jquery-ui-1.8.2.custom')."\n";
		echo $html->css('jQuery/popup/popup.css');
		echo $html->css('jQuery/fg.menu.css'); 

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
	
	// JS added to end of DOM tree...
	
	echo $javascript->link('jquery-1.4.2.min')."\n";
	echo $javascript->link('jquery-ui-1.8.2.custom.min')."\n";
	echo $javascript->link('jquery.ui-datepicker-fr.js')."\n";
	echo $javascript->link('jquery.highlight.js')."\n";
	echo $javascript->link('jquery.popup.js')."\n";
	echo $javascript->link('fg.menu.js')."\n";
	echo $javascript->link('default')."\n";
	echo $javascript->link('storage_layout')."\n";
	echo $javascript->link('browser')."\n";
	echo $javascript->link('copyControl')."\n";
	?>
	
	<script type="text/javascript">
		$(function(){
			initJsControls();
		});
	</script>
	
	<div id="dimForActionPopup"></div>
</body>
</html>