<?php
$this->layout = 'json';
$finalOptions = array(
    'type' => 'add',
    'settings' => array(
        'form_bottom' => false,
        'form_inputs' => false,
        'actions' => false,
        'pagination' => false,
        'header' => __('data types relationship diagram', null)
    ),
    'links' => array()
);
ob_clean();
$this->Structures->build($emptyStructure, $finalOptions);
$html = "<div class='descriptive_heading'>".ob_get_clean()."</div>";

$this->json =  array('page' => json_encode(array('data'=>$dataMartDiagram, 'html'=>$html)));
