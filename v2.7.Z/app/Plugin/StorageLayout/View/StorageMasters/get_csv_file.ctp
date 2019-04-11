<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
$finalAtimStructure = $emptyStructure;
$finalOptions = array(
    'settings' => array(
        'header' => __('aliquot validation summary')
    )
);
$this->Structures->build($finalAtimStructure, $finalOptions);
if ($csvArrayData["valid"]) {
?>
<div class="pop-up-csv-barcode">
<?php
    $numConfirm = $numError = $numWarning = $numTotal = 0;
    foreach ($csvArrayData["data"] as $i => $aliquot) {
        $numTotal ++;
        $message = $aliquot["message"];
        if (empty($message["error"]) && empty($message["warning"])) {
            $numConfirm ++;
        } elseif (! empty($message["error"])) {
            $numError ++;
        } elseif (! empty($message["warning"])) {
            $numWarning ++;
        }
    }
?>
	<ul class="confirm hidden-ul">
		<li data-aliquot="" title="<?php echo __("analyzed = %d\nok = %d\nwarning = %d\nerror = %d", $numTotal, $numConfirm, $numWarning, $numError); ?>">
			<b><?php echo __("number of aliquots analyzed = %d, validated = %d, warning = %d, error = %d", $numTotal, $numConfirm, $numWarning, $numError);?></b>
		</li>
	</ul>
<?php
    foreach ($csvArrayData["data"] as $i => $aliquot) {
        $message = $aliquot["message"];
        $class = (isset($aliquot["class"])) ? $aliquot["class"] : "";
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
        $dataAliquot["OK"] = $aliquot["OK"];
        $dataAliquot["message"] = (! empty($warningMessagePrint)) ? $warningMessagePrint : "";
        $aliquotPositionText = ($aliquot["y"]) ? __("aliquot '%s' [%s-%s]", $dataAliquot["barcode"], $dataAliquot["x"], $dataAliquot["y"]) : __("aliquot '%s' [%s]", $dataAliquot["barcode"], $dataAliquot["x"]);
        
        $aliquot["x"] = (is_numeric($aliquot["x"])) ? abs($aliquot["x"]) : $aliquot["x"];
        $aliquot["y"] = (is_numeric($aliquot["y"])) ? abs($aliquot["y"]) : $aliquot["y"];
        
        if (empty($message["error"]) && empty($message["warning"])) {
?>
	<ul class="confirm" style="display: none">
		<li data-aliquot='<?= json_encode($dataAliquot) ?>' title="<?= __("line %s", $i + 1) ?>" data-class-name="<?=$class?>" class="no-border">
			<?php echo $aliquotPositionText; ?>
		</li>
	</ul>
<?php
 } elseif (! empty($message["error"])) {
?>
	<ul class="error">
		<li data-aliquot='<?= json_encode($dataAliquot) ?>' data-class-name="<?=$class?>" class="no-border">
			<?php echo $i + 1, "- ", $aliquotPositionText, " ", ': ', $errorMessagePrint; ?>
		</li>
	</ul>
<?php
   } elseif (! empty($message["warning"])) {
?>
	<ul class="warning">
		<li data-aliquot='<?= json_encode($dataAliquot) ?>' data-class-name="<?=$class?>" class="no-border">
			<?php echo $i + 1, "- ", $aliquotPositionText, " ", ': ', $warningMessagePrint?>
		</li>
	</ul>
<?php
        }
    }
?>
</div>
<div class="pop-up-csv-barcode-error">
        <?php
    $structureLinks = array(
        'bottom' => array(
            __("add to layout") => array(
                'link' => "javascript:void(0)",
                'icon' => 'add'
            )
        )
    );
} else {
    $structureLinks = array(
        'bottom' => array(
            "cancel" => "javascript:void(0)"
        )
    );
    ?>
        <ul class="error">
		<li><h2><?php echo(__("error")); ?></h2><?php echo($csvArrayData["message"]); ?></li>
	</ul>

</div>
<?php

}
$finalOptions = array(
    'links' => $structureLinks
);
AppController::addWarningMsg(__('click on submit button of the main form to save the loaded records'));
AppController::forceMsgDisplayInPopup();

$this->Structures->build($finalAtimStructure, $finalOptions);