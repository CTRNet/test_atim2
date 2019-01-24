<?php
$model = $formData['model'];
$formBuilderId = $formData['formBuilderId'];
$this->request->data = (!empty($formData['master']))?$formData['indexData']:$formData['indexData'];
$structureLinks = array(
    'top' => "/Administrate/FormBuilders/add/$formBuilderId",
    'bottom' => array(
        'cancel' => "/Administrate/FormBuilders/detail/$formBuilderId"
    )
);

$structureOptions = array(
    'links' => $structureLinks,
    'type' => 'add',
    'settings' =>array(
        'header' => __("control information")
    )
);

$this->Structures->build($atimStructure, $structureOptions);



?>

<script>
    var getI18nVariable = true;
    var i18n = Array();
    var typeValue = "";
    var confirmMessage = "<?php echo __("do you want to update the labels?");?>";
    var alertMessage = "<?php echo __("the labels are already exist and unchangeable");?>";
    
    var copyStr = "<?php echo(__("copy", null)); ?>";
    var pasteStr = "<?php echo(__("paste")); ?>";
    var copyingStr = "<?php echo(__("copying")); ?>";
    var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
    var copyControl = true;

    function getI18n(){
        $.ajax({
            type: 'POST',
            url: root_url + 'Administrate/FormBuilders/getI18n',
            success: function (data) {
                if (isJSON(data)){
                    data = $.parseJSON(data);
                    saveSqlLogAjax(data);
                    var i, id, en, fr;
                    data = JSON.parse(data.page);
                    for (i=0; i<data.length; i++){
                        id = data[i][0]['id'];
                        en = data[i][0]['en'];
                        fr = data[i][0]['fr'];
                        pageId = data[i][0]['page_id'];
                        i18n.push({id: id, en: en, fr: fr, pageId: pageId});
                    }
                }
            }
        });
        
        $(".control-name").on("blur", function (){
            var id = this.value;
            var en = $(".english-label").val();
            var fr = $(".french-label").val();
            $this= $(this);
            typeValue=id.toLowerCase();
            var updateLabel = false;
            var translates = Array();
            if (id.trim()!=""){
                translates = i18n.filter(function(item){
                    return item.id == id;
                });
                if (translates.length == 1 && (en!=translates[0]['en'] ||  fr!=translates[0]['fr'])){
                    if (en == "" || fr == ""){
                        updateLabel = true;
                    }else{
                        updateLabel = window.confirm(confirmMessage);
                    }

                    if (updateLabel){
                        $(".english-label").val(translates[0]['en']);
                        $(".french-label").val(translates[0]['fr']);
                    }else if ((en!=translates[0]['en'] ||  fr!=translates[0]['fr']) && translates[0]['pageId']==""){
                        alert(alertMessage);
                    }
                }else{
                    if (en==""){
                        $(".english-label").val("EN - " + id);
                    }
                    if (fr == ""){
                        $(".french-label").val("FR - " + id);
                    }
                }
            }
        });
        
        
        
    }
    
</script>