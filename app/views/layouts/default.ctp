<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title><?php echo $title_for_layout.' &laquo; '.__('core_appname', true); ?></title>
	
	<?php 
		echo $html->css('style'); 
		echo $html->css('datepicker');

		echo $javascript->link('datepicker');

		echo $javascript->link('prototype');
		echo $javascript->link('scriptaculous');
	?>
	
</head>
<body>
	
<?php 
	echo $shell->header( array('atim_menu'=>$atim_menu,'atim_menu_variables'=>$atim_menu_variables) );
	
	// $session->flash();
	$session->flash('auth');
	
	echo $content_for_layout;
	
	echo $shell->footer();
	
	echo $cakeDebug; 
?>
	
</body>
</html>