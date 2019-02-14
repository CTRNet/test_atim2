    function addValueDomain(e){
        var $this = $(e);
        
        if ($this.css("cursor") == "not-allowed"){
            return false;
        }
        
        var data = $this.data("valueDomain");
        var url = root_url + 'Administrate/FormBuilders/valueDomain/';
        $("#default_popup").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
        $("#default_popup").popup();
        $.ajax({
            data: data,
            traditional: true,
            type: 'POST',
            url: url,
            success: function (data){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));

                var isVisible = $("#default_popup:visible").length;
                
                $popupForm = $("#default_popup");
                $popupForm.html('<div class="wrapper"><div class="frame">' + data + '</div></div>');
                globalInit($popupForm);

                if(isVisible){
                    //recenter popup
                    $popupForm.popup('close');
                    $popupForm.popup();
                }
                $popupForm.popup();
                $popupForm.find("form").eq(0).off("submit").on("submit", function(){
                    var $autoComplete = $popupForm.find("input[type=autocomplete]").eq(0);
                    var valueDomain = {value: $autoComplete.val(), id: (typeof $autoComplete.data("id") !== "undefined")?$autoComplete.data("id"):"0"};
                    $this.data("valueDomain", valueDomain);
                    $this.siblings("span.user-friendly-data").text($autoComplete.val());
                    $this.siblings("span.user-friendly-data").attr("title", $autoComplete.val());
                    if ($autoComplete.val().trim()!=""){
                        $this.parent().find(".fb-value-domain-warning").remove();
                    }else if ($this.parent().find(".fb-value-domain-warning").length == 0){
                        $this.parent().prepend("<span class='fb-value-domain-warning icon16 warning' title = '" + warningValueDomainMessage + "'></span>");
                    }
                    $popupForm.popup("close");
                    return false;
                });
            }        
        });        
    }
    
    function addValidation(e){
        var $this = $(e);
        
        if ($this.css("cursor") === "not-allowed"){
            return false;
        }

        var data = $this.data("validation");
        var url = root_url + 'Administrate/FormBuilders/addValidation/'+$this.closest("tr").find("select.fb_type_select").val();
        $("#default_popup").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
        $("#default_popup").popup();
        $.ajax({
            data: data,
            traditional: true,
            type: 'POST',
            url: url,
            success: function (data) {
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));

                var isVisible = $("#default_popup:visible").length;
                
                $popupForm = $("#default_popup");
                $popupForm.html('<div class="wrapper"><div class="frame">' + data + '</div></div>');
                globalInit($popupForm);

                if(isVisible){
                    //recenter popup
                    $popupForm.popup('close');
                    $popupForm.popup();
                }
                $popupForm.popup();
                
                $trs = $popupForm.find("form table table tr");
                if (addValidationsData == null){
                    addValidationsData = [];
                }
                $trs.each(function() {
                    var $this = $(this);
                    if ($this.find("input").length !== 0) {
                        var shouldDelete = true;
                        addValidationsData.forEach(function(item) {
                            if ($this.find("input[name*=" + item + "]").length > 0) {
                                shouldDelete = false;
                            }
                        });
                        if (shouldDelete) {
                            $this.find("input").prop("disabled", true);
                            $this.find("input").prop("checked", false);
                            $this.find("input").val("");
                        }
                    }
                });
                
                $popupForm.find("input[name*=range_from]").off("change").on("change", function(){
                    var $from = $(this);
                    var $to = $from.closest("td").find("input[name*=range_to]");
                    $to.attr("min", $from.val())
                    if (parseInt($to.val())<parseInt($from.val())){
                        $to.val($from.val());
                    }
                });

                $popupForm.find("input[name*=range_to]").off("change").on("change", function(){
                    var $to = $(this);
                    var $from = $to.closest("td").find("input[name*=range_from]");
                    $from.attr("max", $to.val())
                    if (parseInt($to.val())<parseInt($from.val())){
                        $from.val($to.val());
                    }
                });

                $popupForm.find("input[name*=between_from]").attr("min", "1");
                $popupForm.find("input[name*=between_to]").attr("min", "1");
                
                $popupForm.find("input[name*=between_from]").attr("max", "1000");
                $popupForm.find("input[name*=between_to]").attr("max", "1000");
                
                $popupForm.find("input[name*=between_from]").off("change").on("change", function(){
                    var $from = $(this);
                    var $to = $from.closest("td").find("input[name*=between_to]");
                    $to.attr("min", $from.val())
                    if (parseInt($to.val())<parseInt($from.val())){
                        $to.val($from.val());
                    }
                });

                $popupForm.find("input[name*=between_to]").off("change").on("change", function(){
                    var $to = $(this);
                    var $from = $to.closest("td").find("input[name*=between_from]");
                    $from.attr("max", $to.val())
                    if (parseInt($to.val())<parseInt($from.val())){
                        $from.val($to.val());
                    }
                });

                $popupForm.find("form").eq(0).off("submit").on("submit", function(){
                    
                    $bTo = $popupForm.find("input[name*=between_to]");
                    $bFrom = $popupForm.find("input[name*=between_from]");
                    $rTo = $popupForm.find("input[name*=range_to]");
                    $rFrom = $popupForm.find("input[name*=range_from]");

                    if ($bTo.val() =="" && $bFrom.val()!="" || $bTo.val() !="" && $bFrom.val()==""){
                        $bTo.closest("td").addClass("form-builder-flash-error");
                        setTimeout(function(){
                            $bTo.closest("td").removeClass("form-builder-flash-error");
                        }, 3000);
                        alert(errorToFromMesage);
                        return false;
                    }

                    if ($rTo.val() !="" && $rFrom.val()==""){
                        $rFrom.val("-2147483648");
                    }
                    if ($rTo.val() =="" && $rFrom.val()!=""){
                        $rTo.val("2147483647");
                    }

                    var validationData = $popupForm.find("form").eq(0).serializeArray();
                    $popupForm.find("form").eq(0).find("input[type=hidden]").remove();
                    var validationSerializeData = $popupForm.find("form").eq(0).serialize();
                    validationData = validationData.sort(function (a, b) {
                        return ((a.name < b.name) || (a.name === b.name && a.value > b.value)) ? -1 : 1;
                    }).filter(function (item, index) {
                        return (index === validationData.findIndex(function (item2) {
                            return item2.name === item.name;
                        }));
                    });

                    $this.parent().find(".fb-validation-warning").remove();
                    $this.data("validation", validationData);
                    $this.data("validationSerialise", validationSerializeData);
                    normalised('validation', validationData, $this.siblings("span.user-friendly-data"));

                    $popupForm.popup('close');

                    return false;
                });
            }
        });
    }

    function normalised(type, data, e){
        if (type == 'validation'){
            url = root_url + 'Administrate/FormBuilders/normalised/validation';
        }else if(type == 'valuedomain'){
            url = root_url + 'Administrate/FormBuilders/normalised/valueDomain';
        }

        $.ajax({
            data: data,
            type: 'POST',
            url: url,
            success: function (data) {
                data = JSON.parse(data);
                $(e).text(data.text);
                $(e).attr("title", data.title);
            }
        });
        
    }

    function makeInactiveLink(selector){
        selector.css("opacity", "0.5");
        selector.css("cursor", "not-allowed");
    }
    
    function makeActiveLink(selector){
        selector.css("opacity", "1");
        selector.css("cursor", "pointer");
    }
    
    function checkAllTheTime(){
        $(".removeLineLink").click(function(){
            if ($(this).closest("tbody").children("tr").length == 1){
                return false;
            }
        });
        $addButton = $("<a class='fb_has_validation icon16 add_mini copy-paste-enable' href='javascript:void(0)' title='"+addValidationMessage+"'></a><span class ='user-friendly-data'></span>");
        $("button.fb_has_validation").each(function(){
            $(this).replaceWith($addButton.clone());
        });
        $(".fb_has_validation").off("click").click(function(){
            addValidation(this);
            return false;
        });

        $addButton = $("<a class='fb_is_structure_value_domain_input icon16 add_mini copy-paste-enable' href='javascript:void(0)' title='"+addValueDomainMessage+"'></a><span class ='user-friendly-data'></span>");
        $("button.fb_is_structure_value_domain_input").each(function(){
            $(this).replaceWith($addButton.clone());
        });
        $(".fb_is_structure_value_domain_input").off("click").click(function(){
            addValueDomain(this);
            return false;
        });

        $select = $("select.fb_type_select");
        $select.off("change").change(function(e, b){
            checkSelect($(this), b);
        });
        
    }
    
    function checkSelect(e, b) {
        val = e.val();
        var $parent = e.closest("tr");
        var $valueDomainInput = $parent.find(".fb_is_structure_value_domain_input").eq(0);
        if (val !== 'select') {
            makeInactiveLink($valueDomainInput);
        } else {
            makeActiveLink($valueDomainInput);
        }

        if ([""].indexOf(val) < 0) {
            makeActiveLink($parent.find(".fb_has_validation"));
        } else {
            makeInactiveLink($parent.find(".fb_has_validation"));
        }
        if (b != "autoTriger" && JSON.stringify($parent.find(".fb_has_validation").data()) != "{}" && $parent.find(".fb-validation-warning").length == 0) {
            $parent.find(".fb_has_validation").parent().prepend("<span class='fb-validation-warning icon16 warning' title = '" + warningValidationMessage + "'></span>");
        }

        if (b != "autoTriger" && JSON.stringify($valueDomainInput.data()) == "{}" && $parent.find(".fb-value-domain-warning").length == 0 && val == 'select') {
            $valueDomainInput.parent().prepend("<span class='fb-value-domain-warning icon16 warning' title = '" + warningValueDomainMessage + "'></span>");
        } else if (b != "autoTriger" && val !== 'select') {
            $valueDomainInput.parent().find(".fb-value-domain-warning").remove();
            $valueDomainInput.parent().find(".user-friendly-data").text("");
        } else if (b != "autoTriger" && val == 'select' && $valueDomainInput.siblings("span.user-friendly-data").attr("title")!="") {
            $valueDomainInput.siblings("span.user-friendly-data").text($valueDomainInput.siblings("span.user-friendly-data").attr("title"));
        }

    }

    function commonFunctionAfterLoad(){
           
        checkAllTheTime();
        
        var $select = $("select.fb_type_select");
        $select.each(function(){
            checkSelect($(this));
        });
        
        if (validationData!=""){
            validationData = JSON.parse(validationData);
            validationData.forEach(function(validation, index){
                var $this = $("table[atim-structure=form_builder_structure] a.fb_has_validation").eq(index);
                $this.data("validation", validation);
                normalised('validation', validation, $this.siblings("span.user-friendly-data"));
            });
        }
        
        if (valueDomainData!=""){
            valueDomainData = JSON.parse(valueDomainData);
            valueDomainData.forEach(function(valueDomain, index){
                var $this = $("table[atim-structure=form_builder_structure] a.fb_is_structure_value_domain_input").eq(index);
                $this.data("valueDomain", valueDomain);
                $this.siblings("span.user-friendly-data").text(valueDomain["value"]);
                $this.siblings("span.user-friendly-data").attr("title", valueDomain["value"]);

                if (valueDomain["value"].trim()!=""){
                    $this.parent().find(".fb-value-domain-warning").remove();
                }else if ($this.parent().find(".fb-value-domain-warning").length == 0 && $this.closest("tr select.fb_type_select").val()=="select"){
                    $this.parent().prepend("<span class='fb-value-domain-warning icon16 warning' title = '" + warningValueDomainMessage + "'></span>");
                }

            });
        }
        
    }

    function clickONPlusButton(){
        $(".addLineLink").click(function(){
            checkAllTheTime();
        });
    }

    function clickOnSubmit(){
        var validations = [];
        var valueDomains = [];
        $("div.plugin_Administrate.controller_FormBuilders form").eq(0).on("submit", function(){
            
            $(this).find(".fb_has_validation").each(function(){
                if (typeof $(this).data("validation") !== 'undefined'){
                    validations.push($(this).data("validation"));
                }else{
                    validations.push("");
                }
            });
            
            $(this).find(".fb_is_structure_value_domain_input").each(function(){
                if (typeof $(this).data("valueDomain") !== 'undefined'){
                    valueDomains.push($(this).data("valueDomain"));
                }else{
                    valueDomains.push({"value":"","id":"0"});
                }
            });
            
            $hiddenInput = $("<input type = 'hidden' name = 'validationData'>");
            $(this).append($hiddenInput.val(JSON.stringify(validations)));
            
            $hiddenInput = $("<input type = 'hidden' name = 'valueDomainData'>");
            $(this).append($hiddenInput.val(JSON.stringify(valueDomains)));
            
        });
    }

    function getI18n(){
        
        $(document).ready(function(){
            commonFunctionAfterLoad();
            
            clickONPlusButton();
            
            clickOnSubmit();
           
        });

    }