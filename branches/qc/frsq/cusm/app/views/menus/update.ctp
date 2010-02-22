<?php
	$menu_array = $shell->menu( $ajax_menu, array('variables'=>$ajax_menu_variables) );
	echo $menu_array[0];
?>