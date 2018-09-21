<?php
$chronology['Accuracy']['custom']['date'] = 'date_accuracy';

$finalAtimStructure = $chronology;

$links = array(
    'index' => array(
        'view data' => array(
            'link' => '%%custom.link%%',
            'icon' => 'jsChronology'
        ),
        'access to data' => array(
            'link' => '%%custom.link%%',
            'icon' => 'detail'
        )
    )
);

$finalOptions = array(
    'settings' => array(
        'pagination' => false
    ),
    'type' => 'index',
    'links' => $links,
    'extras' => array(
        10 => '<div id="frame">vive mich</div>'
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);
?>
<script>
    var columnLarge = true;
</script>