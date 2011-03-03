<?php 
ob_start('ob_gzhandler');
?>

<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

	<?php
		$session_delay_sec = AppController::atimSetCookie();
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
		
		<script>
			var root_url = "<?php echo($this->webroot); ?>";
			var webroot_dir = root_url + "/app/webroot/";
			var locale = "<?php echo($locale); ?>";
			var sessionExpiration = (new Date()).getTime() + <?php echo ($session_delay_sec + 1) * 1000; ?>;
			var STR_OR = "<?php __('or'); ?>";
			var STR_SPECIFIC = "<?php __('specific'); ?>";
			var STR_RANGE = "<?php __('range'); ?>";
			var STR_TO = "<?php __('to'); ?>";
			var STR_DELETE_CONFIRM = "<?php __( 'core_are you sure you want to delete this data?') ?>";
			var STR_YES = "<?php __('yes'); ?>";
			var STR_NO = "<?php __('no'); ?>";
			var STR_COPY = "<?php echo(__("copy", null)); ?>";
			var STR_PASTE = "<?php echo(__("paste")); ?>";
			var STR_PASTE_ON_ALL_LINES = "<?php echo(__("paste on all lines")); ?>";
			var STR_LAB_BOOK = "<?php __("lab book"); ?>";
						
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
	
	//TODO: In future version see if $session->flash and $session->flash('auth') works as expected in http://book.cakephp.org/view/1252/Displaying-Auth-Error-Messages
	$session->flash();
	$session->flash('auth');
	//homemade hack because the core seems bugged
	if(!empty($msg_auth) && $this->params['action'] != 'login'){
		echo('<div id="authMessage" class="message">' . $msg_auth['message'] . '</div>');
	}
	
	echo $content_for_layout;
	
	echo $shell->footer();

	echo $this->element('sql_dump');
	
	// JS added to end of DOM tree...
	
	echo $javascript->link('jquery-1.5.min')."\n";
	echo $javascript->link('jquery-ui-1.8.2.custom.min')."\n";
	echo $javascript->link('jquery.ui-datepicker-fr.js')."\n";
	echo $javascript->link('jquery.highlight.js')."\n";
	echo $javascript->link('jquery.popup.js')."\n";
	echo $javascript->link('fg.menu.js')."\n";
	echo $javascript->link('default')."\n";
	echo $javascript->link('storage_layout')."\n";
	echo $javascript->link('datamart')."\n";
	echo $javascript->link('copyControl')."\n";
	echo $javascript->link('ccl')."\n";
	echo $javascript->link('treeViewControl')."\n";
	?>
	
	<script type="text/javascript">
		$(function(){
			initJsControls();
		});
	</script>
	<div id="default_popup" class='hidden std_popup'></div>
</body>
</html>
<?php 
ob_end_flush();
?>