<?php
$menuArray = $this->Shell->menu($ajaxMenu, array(
    'variables' => $ajaxMenuVariables
));
echo $menuArray[0];