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
$headerDescription = __('link to databrowser wiki page %s  + datamart structures relationship diagram access', $helpUrl) . '<a href="' . 'javascript:dataBrowserHelp2();' . '" >' . __('data types relationship diagram') . '</a>';
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
<style>
    #guide-table{
        position: relative;
        top: -350px;
        margin: auto;
    }
    
    #guide-table td{
     width: 205px; 
    text-align: left;
    /* padding-left: 10px; */
    /* display: -webkit-box; */
    /* -webkit-line-clamp: 1; */
    /* white-space: nowrap; */
    overflow: hidden;
    padding: 2px 0px 0px 5px;
    vertical-align: middle;
    }
    
    #data-mart-svg{
        position: relative;
        z-index: 2;
    }

    #data-mart-table{
        position: relative;
        z-index: 1;
        border-collapse: collapse;
    }

    #data-mart-table td{
        width: 70px;
        height: 50px;
        text-align: center;
        border-style: ridge;
        border-color: rgba(127,127,127,.0);
        vertical-align: middle;
    }
    #data-mart-table tbody tr:nth-child(odd){
        background-color: rgba(0, 0, 0, 0);
    }

    #data-mart .data-mart-active{
        stroke: rgba(70,119,191, 1);
    }

    #data-mart line, #data-mart ellipse{
        stroke: rgba(196,196,196, 0.3);
        stroke-linecap: round;
    }

    #data-mart{
        height: 600px!important;
        width: 100%!important;
        overflow: hidden!important;
    }

    #data-mart-graph{
        height: 350px!important;
        width: 100%!important;
        overflow: hidden!important;
    }

    #data-mart .data-mart-node{
        stroke-width: 1;
        fill: #070;
        fill-opacity: 0.01;
    }

    #data-mart .data-mart-from{
        fill-opacity: 0.3;
    }    
    
    .display-name-text{
        font-size: 9pt;
        display: inline-block;
        margin-left: 5px;
    }

    .node-highlight{
        background-color: #DDE8F2;
        -webkit-transition: background-color .5s!important;
        transition: background-color .5s!important;
    }
    
    .guide-table-td-not-selected{
        -webkit-transition: background-color 2s!important;
        transition: background-color 2s!important;
    }

</style>

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

function getDataBrowserDiagram() 
{
    $.get(root_url + "Datamart/Browser/getDataMartDiagram/", function (data) {
        data = $.parseJSON(data);
        saveSqlLogAjax(data);
        data = JSON.parse(data.page);
        var html = createDiagram(data.data);
        $("#dataBeowserDiagramPopup").popup('close');
        $("#dataBeowserDiagramPopup .wrapper").html($(data.html).html());
        $("#dataBeowserDiagramPopup").find(".structure").html(html);
        $("#dataBeowserDiagramPopup").popup();

        globalInit("#dataBeowserDiagramPopup");
    });
}

function createDiagram(data)
{
    idModel = [
        {id: 1, plugin: 'InventoryManagement', model: 'ViewAliquot', 'position':[2, 3]},
        {id: 2, plugin: 'InventoryManagement', model: 'ViewCollection', 'position':[2, 6]},
        {id: 3, plugin: 'StorageLayout', model: 'NonTmaBlockStorage', 'position':[2, 2]},
        {id: 4, plugin: 'ClinicalAnnotation', model: 'Participant', 'position':[2, 7]},
        {id: 5, plugin: 'InventoryManagement', model: 'ViewSample', 'position':[1, 5]},
        {id: 6, plugin: 'ClinicalAnnotation', model: 'MiscIdentifier', 'position':[0, 8]},
        {id: 7, plugin: 'InventoryManagement', model: 'ViewAliquotUse', 'position':[0, 2]},
        {id: 8, plugin: 'ClinicalAnnotation', model: 'ConsentMaster', 'position':[0, 7]},
        {id: 9, plugin: 'ClinicalAnnotation', model: 'DiagnosisMaster', 'position':[4, 7]},
        {id: 10, plugin: 'ClinicalAnnotation', model: 'TreatmentMaster', 'position':[4, 6]},
        {id: 11, plugin: 'ClinicalAnnotation', model: 'FamilyHistory', 'position':[2, 9]},
        {id: 12, plugin: 'ClinicalAnnotation', model: 'ParticipantMessage', 'position':[1, 9]},
        {id: 13, plugin: 'InventoryManagement', model: 'QualityCtrl', 'position':[4, 4]},
        {id: 14, plugin: 'ClinicalAnnotation', model: 'EventMaster', 'position':[4, 8]},
        {id: 15, plugin: 'InventoryManagement', model: 'SpecimenReviewMaster', 'position':[0, 5]},
        {id: 16, plugin: 'Order', model: 'OrderItem', 'position':[3, 2]},
        {id: 17, plugin: 'Order', model: 'Shipment', 'position':[4, 2]},
        {id: 18, plugin: 'ClinicalAnnotation', model: 'ParticipantContact', 'position':[4, 9]},
        {id: 19, plugin: 'ClinicalAnnotation', model: 'ReproductiveHistory', 'position':[3, 9]},
        {id: 20, plugin: 'ClinicalAnnotation', model: 'TreatmentExtendMaster', 'position':[4, 5]},
        {id: 21, plugin: 'InventoryManagement', model: 'AliquotReviewMaster', 'position':[0, 3]},
        {id: 22, plugin: 'Order', model: 'Order', 'position':[4, 1]},
        {id: 23, plugin: 'StorageLayout', model: 'TmaSlide', 'position':[1, 1]},
        {id: 24, plugin: 'StorageLayout', model: 'TmaBlock', 'position':[1, 2]},
        {id: 25, plugin: 'Study', model: 'StudySummary', 'position':{'exception': [[0, 1], [4, 0], [1, 4], [0, 6], [0, 9]]}},
        {id: 26, plugin: 'Order', model: 'OrderLine', 'position':[3, 1]},
        {id: 27, plugin: 'StorageLayout', model: 'TmaSlideUse', 'position':[1, 0]}
    ];

    a = idModel.map(function(item){return {plugin: item['plugin'], model: item['model']};});
    b = data['idModel'].map(function(item){return {plugin: item['plugin'], model: item['model']};});
    a.sort(function(x, y){
        return x["plugin"].localeCompare(y["plugin"]);
    });
    b.sort(function(x, y){
        return x["plugin"].localeCompare(y["plugin"]);
    });
    a = JSON.stringify(a);
    b = JSON.stringify(b);
    dms = data['idModel'];

    addPosition(dms);
    dmbc = data['dmbc'];
    if (a != b) {
        alert("The datamart_structures table is not correspond to the default and so the result of data browsing is not guarantied.");
    }
    var div = drawDataMartDiagram(dms, dmbc);
    return div;
}

function makeExceptions(dms) 
{
    exception = [];
    exception.push({'e1': [25, 27], 'e2': [0, 1]});
    exception.push({'e1': [25, 23], 'e2': [0, 1]});
    exception.push({'e1': [25, 7], 'e2': [0, 1]});
    exception.push({'e1': [25, 26], 'e2': [4, 0]});
    exception.push({'e1': [25, 22], 'e2': [4, 0]});
    exception.push({'e1': [25, 1], 'e2': [1, 4]});
    exception.push({'e1': [25, 8], 'e2': [0, 6]});
    exception.push({'e1': [25, 6], 'e2': [0, 9]});
    
    exceptions = [];

    exception.forEach(function(ex){
        x1 = dms.find(function(item){return ex.e1[0] == item.id1;});
        x2 = dms.find(function(item){return ex.e1[1] == item.id1;});
        exceptions[x1.id+'-'+x2.id ] = ex.e2;
    });

    return exceptions;
}

function createGuideTable(rows, cols)
{
    var guideTable = $("<Table id = 'guide-table'><tbody>");
    for(var r = 0; r < rows; r++)
    {
        var tr = $('<tr>');
        for (var c = 0; c < cols; c++)
            $('<td class = "guide-table-td-not-selected"></td>').appendTo(tr);
        tr.appendTo(guideTable);
    }    
    return guideTable;
}

function drawDataMartDiagram(dms, dmbc) 
{
    var verticalDistance = 70, horizontalDistance = 70;
    var exceptions = makeExceptions(dms);
    var div = $("<div id='data-mart'></div>");
    div.html("");
    div.append("<table id='data-mart-table'>");
    div.append("<svg>");

    var table = $(div.find("table"));
    var svg = $(div.find("svg"));
    var i, j;
    for (i = 0; i < 5; i++) {
        table.append("<tr id = 'dm-row-" + i + "'></tr>");
        for (j = 0; j < 10; j++) {
            td = "<td id = 'dm-cell-" + i + "-" + j + "'></td>";
            table.find("tr").eq(i).append(td);
        }
    }
    svg.attr("id", "data-mart-svg");
    svg.css("top", "-350px");
    svg.attr("height", "350px");
    svg.attr("width", "700px");

    for (i in dmbc) {
        var id1 = dmbc[i]['id1'];
        var id2 = dmbc[i]['id2'];
        var active = dmbc[i]['isActive'];

        if (typeof exceptions[id1 + "-" + id2] === 'undefined' && typeof exceptions[id2 + "-" + id1] === 'undefined') {
            dmsTemp1 = dms.find(function (item) {
                return item.id == id1;
            });
            dmsTemp2 = dms.find(function (item) {
                return item.id == id2;
            });
            x1 = dmsTemp1.position[0];
            y1 = dmsTemp1.position[1];
            x2 = dmsTemp2.position[0];
            y2 = dmsTemp2.position[1];
        } else if (typeof exceptions[id1 + "-" + id2] !== 'undefined') {
            x1 = exceptions[id1 + "-" + id2][0];
            y1 = exceptions[id1 + "-" + id2][1];
            dmsTemp2 = dms.find(function (item) {
                return item.id == id2
            });
            x2 = dmsTemp2.position[0];
            y2 = dmsTemp2.position[1];
        } else if (typeof exceptions[id2 + "-" + id1] !== 'undefined') {
            x1 = exceptions[id2 + "-" + id1][0];
            y1 = exceptions[id2 + "-" + id1][1];
            dmsTemp1 = dms.find(function (item) {
                return item.id == id1
            });
            x2 = dmsTemp1.position[0];
            y2 = dmsTemp1.position[1];
        }

        activeClass = (active) ? "data-mart-active" : "data-mart-passive";
        td1 = table.find("#dm-cell-" + x1 + "-" + y1);
        td2 = table.find("#dm-cell-" + x2 + "-" + y2);
        x1 = Math.floor(td1.index()*horizontalDistance + horizontalDistance / 2);
        y1 = Math.floor(td1.closest("tr").index() * verticalDistance + verticalDistance / 2);
        x2 = Math.floor(td2.index()*horizontalDistance + horizontalDistance / 2);
        y2 = Math.floor(td2.closest("tr").index() * verticalDistance + verticalDistance / 2);

        distance = 10;
        if (x1 < x2) {
            x1 += distance;
            x2 -= distance;
        } else if (x2 < x1) {
            x1 -= distance;
            x2 += distance;
        }

        if (y1 < y2) {
            y1 += distance;
            y2 -= distance;
        } else if (y2 < y1) {
            y1 -= distance;
            y2 += distance;
        }

        if (id1 != id2) {
            var line2 = $(document.createElementNS('http://www.w3.org/2000/svg', 'line')).attr({
                    id: 'line-' + i, x1: x1, y1: y1, x2: x2, y2: y2, class: activeClass, id1: id1, id2: id2
                }).css("stroke-width", "4").off('mouseover').on('mouseover', function(){
                var index1 = $(this).attr("id1");
                var index2 = $(this).attr("id2");
                var tdIndex1 = $("#guide-table td[data-index="+index1+"]");
                var tdIndex2 = $("#guide-table td[data-index="+index2+"]");
                tdIndex1.addClass("node-highlight");
                tdIndex2.addClass("node-highlight");
                tdIndex1.removeClass("guide-table-td-not-selected");
                tdIndex2.removeClass("guide-table-td-not-selected");
            }).off('mouseout').on('mouseout', function(){
                var index1 = $(this).attr("id1");
                var index2 = $(this).attr("id2");
                var tdIndex1 = $("#guide-table td[data-index="+index1+"]");
                var tdIndex2 = $("#guide-table td[data-index="+index2+"]");
                tdIndex1.addClass("guide-table-td-not-selected");
                tdIndex2.addClass("guide-table-td-not-selected");
                tdIndex1.removeClass("node-highlight");
                tdIndex2.removeClass("node-highlight");
            });
            svg.append(line2);
        } 
    }
    
    var rows = 9;
    var cols = 3;
    var guideTable = createGuideTable(rows, cols);

    nameLanguageObj = createNodeDisplayName();

    for (i in dms) {
        id = dms[i].id;
        name = nameLanguageObj[dms[i].name][(STR_LANGUAGE=='fr')?1:0];
        var index = nameLanguageObj[dms[i].name][2];
        img = "<img src='"+root_url+"img/datamart/" + id + ".png' alt = '" + name + "' title = '" + name + "'>";
        img2 = "<img src='"+root_url+"img/datamart/" + id + ".png' alt = '" + name + "'>" + "<span class = 'display-name-text'>"+name+"</span>";
        guideTable.find("td").eq((index / rows) + (index%rows)*cols).attr("data-index", parseInt(i)+1).html(img2);
        if (typeof dms[i].position[0] !== "undefined") {
            x = dms[i].position[0];
            y = dms[i].position[1];
            td = table.find("#dm-cell-" + x + "-" + y).prepend(img);

            x = Math.floor(td.index()*horizontalDistance + verticalDistance / 2);
            y = Math.floor(td.closest("tr").index()*verticalDistance + verticalDistance / 2);
            var circle = $(document.createElementNS('http://www.w3.org/2000/svg', 'circle')).attr({cx: x, cy: y, r: 10, class: "data-mart-node"});

            svg.append(circle);
            var text = $(document.createElementNS('http://www.w3.org/2000/svg', 'title'));
            svg.children(":last-child").append(text);
            svg.children(":last-child").children().text(name);
        } else {
            ex = dms[i].position.exception;
            for (j in ex) {
                x = ex[j][0];
                y = ex[j][1];
                td = table.find("#dm-cell-" + x + "-" + y).prepend(img);

                x = Math.floor(td.index()*horizontalDistance + horizontalDistance / 2);
                y = Math.floor(td.closest("tr").index()*verticalDistance + verticalDistance / 2);
                var circle = $(document.createElementNS('http://www.w3.org/2000/svg', 'circle')).attr({cx: x, cy: y, r: 10, class: "data-mart-node"});

                svg.append(circle);
                var text = $(document.createElementNS('http://www.w3.org/2000/svg', 'title'));
                svg.children(":last-child").append(text);
                svg.children(":last-child").children().text(name);

            }
        }
    }
    div.append(guideTable);
    return div;
}

function createNodeDisplayName()
{
    nameLanguage = [
        ['aliquot review', 'Aliquot Review', 'Analyse d\'aliquot'], 
        ['aliquot uses and events', 'Aliquot Uses/Events', 'Utilisations/événements d\'aliquote'], 
        ['aliquots', 'Aliquots', 'Aliquotes'], 
        ['annotation', 'Annotation', 'Annotation'], 
        ['collections', 'Collections', 'Collections'], 
        ['consents', 'Consents', 'Consentements'], 
        ['diagnosis', 'Diagnosis', 'Diagnostic'], 
        ['storage (non tma block) - value generated by newVersionSetup function', 'Storage (Non TMA Block)', 'Entreposage (Bloc de TMA exclu)'], 
        ['family histories', 'Family histories', 'Historiques familiale'], 
        ['identification', 'Identification', 'Identification'], 
        ['order', 'Order', 'Commande'], 
        ['order items', 'Order Items', 'Articles de Commande'], 
        ['order line', 'Order Line', 'Ligne de commande'], 
        ['participant contacts', 'Participant contacts', 'Contacts des participants'], 
        ['participant messages', 'Participant messages', 'Messages des participants'], 
        ['participants', 'Participants', 'Participants'], 
        ['specimen review', 'Path Review', 'Rapport d\'histologie'], 
        ['quality controls', 'Quality Controls', 'Contrôles de qualité'], 
        ['reproductive histories', 'Reproductive histories', 'Gynécologie'], 
        ['samples', 'Samples', 'Echantillons'], 
        ['shipments', 'Shipments', 'Envois'], 
        ['tma blocks (storages sub-set)', 'Storages (TMA Blocks)', 'Entreposages (Blocs TMA)'], 
        ['study', 'Study', 'Étude'], 
        ['tma slide', 'TMA slide', 'Lame de TMA'], 
        ['tma slide uses', 'TMA Slide Analysis', 'Analyse de lame (TMA)'], 
        ['treatment precision', 'Treatment Precision', 'Précisions de Traitment'], 
        ['treatments', 'Treatments', 'Traitements'], 
    ];
    nameLanguage.sort(function(a, b){
        return (STR_LANGUAGE=='fr')?a[2].localeCompare(b[2]): a[1].localeCompare(b[1]);
    });

    nameLanguageObj = {};
    var i=0;
    nameLanguage.forEach(function(item){
        nameLanguageObj[item[0]] = [item[1], item[2], i++];
    });
    
    return nameLanguageObj;
}

function addPosition(dms)
{
    dms.forEach(function(dmsItem, i, dmsItems){
        var idModelItem = idModel.find(function(item){ return (item.plugin == dmsItem.plugin && item.model == dmsItem.model);});
        dmsItems[i]['position'] = idModelItem['position'];
        dmsItems[i]['id1'] = idModelItem['id'];
    });
}

function dataBrowserHelp2() 
{
    if ($("#dataBeowserDiagramPopup").length == 0) {
        buildDialog("dataBeowserDiagramPopup", null, null, null);
        $("#dataBeowserDiagramPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
        $("#dataBeowserDiagramPopup").removeClass("std_popup").removeClass("question");
        getDataBrowserDiagram();
    }
    $("#dataBeowserDiagramPopup").popup();
}

</script>