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
};

jQuery.fn.popup = function(options){
	var fmPopup = $(this).data('FmPopup') == undefined ? new FmPopup(this) : $(this).data('FmPopup');
	if(options != undefined && options.closable != undefined){
		fmPopup.closable = options.closable; 
	}
	
	if(fmPopup.popupOuter == null){
		$("body").append("<div class='popup_outer'>"
				+ "<div class='popup_container'></div>"
				+ "<div class='popup_close'><a href='#'>X</a></div>"
				+ "</div>");
		fmPopup.popupOuter = $("body div.popup_outer:last"); 
		$(".popup_outer").click(function(){
			if(fmPopup.closePop && fmPopup.closable){
				console.log(fmPopup.closable);
				$(fmPopup.popupOuter).hide();
			}else{
				fmPopup.closePop = true;
			}
		});
		$(document).keyup(function(event) {
			if(event.keyCode == 27 && fmPopup.closable) { // Capture Esc key
				$(fmPopup.popupOuter).hide();
			}
		});
		
		$(this).css({
			"margin" : "auto",
			"position" : "relative"
		});
		
		$(fmPopup.popupOuter).find(".popup_container").append($(this));
		if(fmPopup.closable){
			(fmPopup.popupOuter).find(".popup_container").append($(fmPopup.popupOuter).find(".popup_close"));
		}
	}
	
	if(options == "close"){
		$(fmPopup.popupOuter).hide();
	}else{
		$(this).show();
		var container = $(fmPopup.popupOuter).find(".popup_container");
		$(fmPopup.popupOuter).show();
		container.css({
			left : $(window).width() / 2 - container.width() / 2 + "px",
			top : $(window).height() / 2 - container.height() / 2 + "px"
		});
	}
	
	
}
