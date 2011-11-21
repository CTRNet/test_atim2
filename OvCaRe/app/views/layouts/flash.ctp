<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title><?php echo $page_title.' &laquo; '.__('core_appname', true); ?></title>
	<link rel="shortcut icon" href="favicon.ico" type="image/ico" />

	<?php 
		echo $html->css('style');
		echo $html->charset('UTF-8');
	 ?>

	
</head>

<body class="flash">

    <div class="wrapper">
		<a href="<?php echo $url; ?>"> 
        	<?php echo __( $message, true ); ?>
        	<br/>
	        <small><?php __('click to continue'); ?></small>
		</a>
    </div>
    <?php
    	echo $this->element('sql_dump');
    ?>
    
</body>

</html>