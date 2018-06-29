<?php
$finalAtimStructure = $emptyStructure;
$finalOptions = array(
    'settings' => array(
        'header' => __('the aliquots list'),
    ),
);
$this->Structures->build($finalAtimStructure, $finalOptions);
if ($csvArrayData["valid"]) {
    ?>
    <div class="pop-up-csv-barcode">
        <h2><?= __("barcode") ?>, X, Y, <?= __("message") ?></h2>
        <?php
        foreach ($csvArrayData["data"] as $i => $aliquot) {
            $message = $aliquot["message"];
            $class = (isset($aliquot["class"]))?$aliquot["class"]:"";
            $errorMessagePrint = implode(", ", $message['error']);
            $warningMessagePrint = implode(", ", $message['warning']);

            $dataAliquot = array();
            $dataAliquot["id"] = ($aliquot["id"]) ? $aliquot["id"] : "";
            $dataAliquot["label"] = ($aliquot["label"]) ? $aliquot["label"] : "";
            $dataAliquot["collectionId"] = ($aliquot["collectionId"]) ? $aliquot["collectionId"] : "";
            $dataAliquot["sampleMasterId"] = ($aliquot["sampleMasterId"]) ? $aliquot["sampleMasterId"] : "";
            $dataAliquot["barcode"] = ($aliquot["barcode"]) ? $aliquot["barcode"] : "";
            $dataAliquot["x"] = ($aliquot["x"]) ? $aliquot["x"] : "";
            $dataAliquot["y"] = ($aliquot["y"]) ? $aliquot["y"] : "1";
            $dataAliquot["message"] = (!empty($warningMessagePrint)) ? $warningMessagePrint : "";
            
            $aliquot["x"] = (is_numeric($aliquot["x"]))?abs($aliquot["x"]):$aliquot["x"];
            $aliquot["y"] = (is_numeric($aliquot["y"]))?abs($aliquot["y"]):$aliquot["y"];

            if (empty($message["error"]) && empty($message["warning"])) {
                ?>
                <ul class="confirm">
                    <li data-aliquot='<?= json_encode($dataAliquot) ?>' title ="<?= __("line %s", $i + 1) ?>" data-class-name="<?=$class?>" class = "no-border"><?= $aliquot['barcode'], ", ", $aliquot['x'], ", ", $aliquot['y']; ?></li>        
                </ul>
                <?php
            } elseif (!empty($message["error"])) {
                ?>
                <ul class="error">
                    <li data-aliquot='<?= json_encode($dataAliquot) ?>' data-class-name="<?=$class?>" class = "no-border"><?= $aliquot['barcode'], ", ", $aliquot['x'], ", ", $aliquot['y'], ", ", __("line %s", $i + 1), ': ', $errorMessagePrint; ?></li>        
                </ul>
                <?php
            } elseif (!empty($message["warning"])) {
                ?>
                <ul class="warning">
                    <li data-aliquot='<?= json_encode($dataAliquot) ?>' data-class-name="<?=$class?>" class = "no-border"><?= $aliquot['barcode'], ", ", $aliquot['x'], ", ", $aliquot['y'], ", ", __("line %s", $i + 1), ': ', $warningMessagePrint; ?></li>        
                </ul>
                <?php
            }
        }
        ?>
    </div>
    <div class="pop-up-csv-barcode-error">
        <?php
        $structureLinks = array(
            'bottom' => array("add" => "javascript:void(0)")
        );
    } else {
        $structureLinks = array(
            'bottom' => array("cancel" => "javascript:void(0)")
        );
        ?>
        <ul class="error">
            <li><h2><?php echo(__("error")); ?></h2><?php echo($csvArrayData["message"]); ?></li>
        </ul>    

    </div>
    <?php
}
$finalOptions = array(
    'links' => $structureLinks,
);
$this->Structures->build($finalAtimStructure, $finalOptions);
