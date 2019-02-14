/**
 * Script for displaying popups
 * @author: FM L'Heureux
 * @date: 2010-07-10
 * @version: 0.0.1
 * @see: http://frank-mich.com/
 **/
var FmPopup = function(popup){
	$(popup).data('FmPopup', this);
	this.closePop = true;
	this.closable = true;
	this.popupOuter = null;
	this.retainFocus = FmPopup.prototype.retainFocus;
};

jQuery.fn.popup = function(options){
    setPopUpTabIndex();
	var fmPopup = $(this).data('FmPopup') == undefined ? new FmPopup(this) : $(this).data('FmPopup');
	if(options != undefined && options.closable != undefined){
		fmPopup.closable = options.closable; 
	}
	
	if(fmPopup.popupOuter == null){
		$("body").append("<div class='popup_outer'>"
				+ "<div class='popup_container'></div>"
				+ "<div class='popup_close'><a href='javascript:void(0)'>X</a></div>"
				+ "</div>");
		fmPopup.popupOuter = $("body div.popup_outer:last");
		fmPopup.popupOuter.data("FmPopup.prototype.id", FmPopup.prototype.id ++);
		if(options != undefined && options.background != undefined){
			fmPopup.popupOuter.css("background", options.background);
		}
		$(fmPopup.popupOuter).click(function(){
			if(fmPopup.closePop && fmPopup.closable){
				$(fmPopup.popupOuter).hide();
                                setMainFormTabIndex();
			}else{
				fmPopup.closePop = true;
			}
		});
		$(fmPopup.popupOuter).find(".popup_container").click(function(event){
			fmPopup.closePop = false;
		});
		$(document).keyup(function(event) {
			if(event.keyCode == 27 && fmPopup.closable) { // Capture Esc key
				//TODO: close only toppest popup
				$(fmPopup.popupOuter).hide();
                                setMainFormTabIndex();
			}
		});
		
		$(this).css({
			"margin" : "auto",
			"position" : "relative"
		});
		
		fmPopup.popupOuter.find(".popup_container").append($(this));
		if(fmPopup.closable){
			fmPopup.popupOuter.find(".popup_container").append(fmPopup.popupOuter.find(".popup_close"));
			fmPopup.popupOuter.find(".popup_close").click(function(){fmPopup.popupOuter.hide();setMainFormTabIndex();});
		}else{
			fmPopup.popupOuter.find(".popup_close").hide();
                        setMainFormTabIndex();
		}
	}
	
	if(options == "close"){
		fmPopup.popupOuter.hide();
                setMainFormTabIndex();
	}else if(options == "center"){
		if(fmPopup.popupOuter.find(":first:visible")){
			var container = $(fmPopup.popupOuter).find(".popup_container");
			container.css({
				left : $(window).width() / 2 - container.width() / 2 + "px",
				top : $(window).height() / 2 - container.height() / 2 + "px"
			});
		}
	}else{
		$(this).show();
		var container = $(fmPopup.popupOuter).find(".popup_container");
		$(fmPopup.popupOuter).show();
                $(fmPopup.popupOuter).find("input[type!='hidden'], select").eq(0).focus();
		container.css({
			left : $(window).width() / 2 - container.width() / 2 + "px",
			top : $(window).height() / 2 - container.height() / 2 + "px"
		});
		
		fmPopup.popupOuter.find(":tabbable").unbind('keydown', fmPopup.retainFocus).keydown(fmPopup, fmPopup.retainFocus);
	}
	
	
};
FmPopup.prototype.id = 1;
/**
 * Keeps focus within the popup at all times
 * @param event
 * @returns {Boolean}
 */
FmPopup.prototype.retainFocus = function(event){
	if(event.keyCode == 9){
		$(":focus").data("FmPopup.startingFocus", true);
		if(event.data.popupOuter.find(event.shiftKey ? ":tabbable:first" : ":tabbable:last").data("FmPopup.startingFocus")){
			$(":focus").data("FmPopup.startingFocus", null);
			event.data.popupOuter.find(event.shiftKey ? ":tabbable:last" : ":tabbable:first").focus();
			return false;
		}
		$(":focus").data("FmPopup.startingFocus", null);
		return true;
	}
};

function setMainFormTabIndex(){
    $(".mainFieldset").find("input, textarea, select, button, a").each(function(){
        var $this = $(this);
        var tabIndex = $this.attr("data-tabindex-old");
        $this.attr("tabindex", tabIndex);
    });
}

function setPopUpTabIndex(){
    $(".mainFieldset").find("input, textarea, select, button, a").each(function(){
        var $this = $(this);
        var tabIndex = $this.attr("tabindex");
        if (tabIndex =="" || tabIndex == 0 || isNaN(tabIndex) || tabIndex>0){
            $this.attr("data-tabindex-old", tabIndex);
            $this.attr("tabindex", -9999);
        }
    });
}