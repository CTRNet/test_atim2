<?php
class VersionsControllerCustom extends VersionsController{
    
    var $uses = array('Version');
    
    function custom(){
        echo '<span class="custom_controller">This is a custom ctrl</span><br/>';
        echo '<span>'.$this->Version->custom.'</span>';
        $this->layout = false;
        $this->render(false);
    }
}