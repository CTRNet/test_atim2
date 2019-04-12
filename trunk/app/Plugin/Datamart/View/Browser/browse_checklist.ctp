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
if (isset($nodeId) && $nodeId != 0) {
    echo Browser::getPrintableTree($nodeId, isset($mergedIds) ? $mergedIds : array(), $this->request->webroot);
}
// use add as type to avoid advanced search usage
$settings = array();
$links['bottom']['new'] = '/Datamart/Browser/browse/';
if (isset($isRoot) && ! $isRoot) {
    $links['bottom']['save browsing steps'] = array(
        'link' => AppController::checkLinkPermission('/Datamart/BrowsingSteps/save/') ? 'javascript:openSaveBrowsingStepsPopup("Datamart/BrowsingSteps/save/' . $nodeId . '");' : '/underdev/',
        'icon' => 'disk'
    );
}

if ($type == "checklist") {
    $links['top'] = $top;
    if (is_array($this->request->data)) {
        // normal display
        $links['checklist'] = array(
            $checklistKeyName . '][' => '%%' . $checklistKey . '%%'
        );
        if (isset($index) && strlen($index) > 0) {
            $links['index'] = array(
                array(
                    'link' => $index,
                    'icon' => 'detail'
                )
            );
        }
        $tmpHeader = isset($header) ? $header : "";
        $header = __("select an action");
        $this->Structures->build($resultStructure, array(
            'type' => "index",
            'links' => $links,
            'settings' => array(
                'form_bottom' => false,
                'actions' => false,
                'pagination' => false,
                'sorting' => array(
                    $nodeId,
                    $controlId,
                    $mergeTo
                ),
                'form_inputs' => false,
                'header' => $tmpHeader,
                'data_miss_warn' => ! isset($mergedIds)
            )
        ));
    } else {
        // overflow
        ?>
<ul class="warning">
	<li><span class="icon16 warning mr5px"></span><?php
        
        echo (__("the query returned too many results") . ". " . __("try refining the search parameters") . ". " . __("for any action you take (%s, %s, csv, etc.), all matches of the current set will be used", __('browse'), __('batchset')));
        ?>.</li>
</ul>
<?php

        $this->Structures->build($empty, array(
            'data' => array(),
            'type' => 'add',
            'links' => $links,
            'settings' => array(
                'actions' => false,
                'form_bottom' => false
            )
        ));
        $keyParts = explode(".", $checklistKey);
        echo ("<input type='hidden' name='data[" . $keyParts[0] . "][" . $keyParts[1] . "]' value='all'/>\n");
    }
    $isDatagrid = true;
    $type = "add";
    ?>
<input type="hidden" name="data[node][id]"
	value="<?php echo($nodeId); ?>" />
<?php
    
    if ($unusedParent) {
        $links['bottom']['unused parents'] = '/Datamart/Browser/unusedParent/' . $nodeId;
    }
} else {
    $isDatagrid = false;
}
$links['top'] = $top;

$extras = array(
    'end' => '<a id="actionsTarget"></a>'
);
if (isset($nodeId)) {
    $extras['end'] .= $this->Form->input('node.id', array(
        'type' => 'hidden',
        'value' => $nodeId
    ));
}
$headerTitle = __("select an action");
$headerDescription = __('link to databrowser wiki page %s  + datamart structures relationship diagram access', $helpUrl) . '<a href="' . 'javascript:dataBrowserHelp();' . '" >' . __('data types relationship diagram') . '</a>';
if (isset($header)) {
    if (! is_array($header)) {
        $headerTitle = $header;
    } elseif (array_key_exists('title', $header)) {
        $headerTitle = $header['title'];
        if (array_key_exists('description', $header)) {
            $headerDescription = $header['description'] . '<br>' . $headerDescription;
        }
    }
}
$this->Structures->build($atimStructure, array(
    'type' => $type,
    'links' => $links,
    'data' => array(),
    'settings' => array(
        'form_top' => ! $isDatagrid,
        'header' => array(
            'title' => $headerTitle,
            'description' => $headerDescription
        )
    ),
    'extras' => $extras
));
?>
<script>
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(stringCorrection(Sanitize::clean($dropdownOptions))); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
var STR_BACK = '<?php echo __('back'); ?>';
var csvMergeData = '<?php echo json_encode(isset($csvMergeData) ? $csvMergeData : array()) ; ?>';
var STR_DATAMART_STRUCTURE_RELATIONSHIPS = "<?php echo __('data types relationship diagram'); ?>";
var STR_LANGUAGE = "<?php echo (($_SESSION['Config']['language'] == 'eng')? 'en' : 'fr'); ?>";
</script>