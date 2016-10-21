<?php
$structure_links = array(
   'top' => '/users/reset_password/',
);

echo "<div class='validation hidden' id='timeErr'><ul class='warning'><li>".__("server_client_time_discrepency")."</li></ul></div>";
$this->Structures->build(
   $atim_structure, array(
      'type'=>'edit',
      'links'=>$structure_links,
      'settings' => array('tabindex' => 1000)
   )
);
