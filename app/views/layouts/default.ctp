<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

	<?php
		$header = $shell->header( array('atim_menu_for_header'=>$atim_menu_for_header,'atim_menu'=>$atim_menu,'atim_menu_variables'=>$atim_menu_variables) );
		$title = $this->loaded['shell']->pageTitle;
	?>
	
	<title><?php echo $title.' &laquo; '.__('core_appname', true); ?></title>
	
	<?php 
		echo $html->css('style')."\n"; 
		echo $html->css('datepicker')."\n";
		echo $html->css('lightwindow')."\n";

		echo $javascript->link('datepicker')."\n";
		echo $javascript->link('prototype')."\n";
		echo $javascript->link('scriptaculous.js?load=effects,dragdrop')."\n";
		echo $javascript->link('lightwindow')."\n";
		echo $javascript->link('default')."\n";
		
	?>
	
</head>
<body>
	
<?php 
	echo $header;
	
	// $session->flash();
	$session->flash('auth');
	
	echo $content_for_layout;
	
	echo $shell->footer();

	echo $cakeDebug; 
?>
	
</body>
</html>