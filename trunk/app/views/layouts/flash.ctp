<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title><?php echo $page_title.' &laquo; '.__('core_appname', true); ?></title>
	
	<?php if ( Configure::read("debug") == 0 ) { ?>
	<meta http-equiv="Refresh" content="<?php echo $pause?>; url=<?php echo $url?>" />
	<?php } ?>

	<link rel="shortcut icon" href="favicon.ico" type="image/ico" />

	<?php 
		echo $html->css('style');
		echo $html->charset('UTF-8');
	 ?>

	
</head>

<body class="flash">

    <div class="wrapper">
        <a href="<?php echo $url; ?>"> <?php echo __( $message, true ); ?> </a>
    </div>
    
    <?php
    	echo $this->element('sql_dump');
    ?>
    
</body>

</html>