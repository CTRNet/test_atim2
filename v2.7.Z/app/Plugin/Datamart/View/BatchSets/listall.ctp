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
// display adhoc DETAIL
$this->Structures->build($atimStructureForDetail, array(
    'type' => 'detail',
    'settings' => array(
        'actions' => false,
        'no_sanitization' => array(
            'BatchSet' => array(
                'title'
            )
        )
    ),
    'data' => $dataForDetail
));

// display adhoc RESULTS form
$structureLinks = array(
    'top' => '#',
    'checklist' => array(
        $lookupModelName . '.' . $lookupKeyName . '][' => '%%' . $dataForDetail['BatchSet']['model'] . '.' . $dataForDetail['BatchSet']['lookup_key_name'] . '%%'
    )
);

// append LINKS from DATATABLE, if any...
if (count($ctrappFormLinks)) {
    $structureLinks['index'] = $ctrappFormLinks;
}

// $addToBatchsetHiddenField = '<input type="hidden" name="data[BatchSet][id]" value="'.$dataForDetail['BatchSet']['id'].'"/>';
$addToBatchsetHiddenField = $this->Form->input('BatchSet.id', array(
    'type' => 'hidden',
    'value' => $dataForDetail['BatchSet']['id']
));

$this->Structures->build($atimStructureForResults, array(
    'type' => 'index',
    'data' => $results,
    'settings' => array(
        'form_bottom' => false,
        'header' => __('elements', null),
        'form_inputs' => false,
        'actions' => false,
        'pagination' => false,
        'sorting' => array(
            $dataForDetail['BatchSet']['id']
        )
    ),
    'links' => $structureLinks,
    'extras' => array(
        'end' => $addToBatchsetHiddenField
    )
));

// display adhoc-to-batchset ADD form
$structureLinks = array(
    'top' => '#',
    'bottom' => array(
        'edit' => '/Datamart/BatchSets/edit/' . $atimMenuVariables['BatchSet.id'],
        'delete' => '/Datamart/BatchSets/delete/' . $atimMenuVariables['BatchSet.id']
    )
);
if ($displayUnlockButton)
    $structureLinks['bottom'] = array_merge(array(
        'unlock' => '/Datamart/BatchSets/unlock/' . $atimMenuVariables['BatchSet.id']
    ), $structureLinks['bottom']);

$this->Structures->build($atimStructureForProcess, array(
    'type' => 'add',
    'settings' => array(
        'form_top' => false,
        'header' => __('actions', null)
    ),
    'links' => $structureLinks,
    'data' => array(),
    'extras' => array(
        'end' => '<div id="actionsTarget"></div>'
    )
));

?>
<div id="popup" class="std_popup question">
	<div style="background: #FFF;">
		<h4><?php echo __("you are about to remove element(s) from the batch set"); ?></h4>
		<p>
		<?php echo __("do you wish to proceed?"); ?>
		</p>
		<span class="button confirm"> <a class="form detail"><?php echo __("yes"); ?></a>
		</span> <span class="button close"> <a class="form delete"><?php echo __("no"); ?></a>
		</span>
	</div>
</div>

<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(stringCorrection(Sanitize::clean($actions))); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
</script>