/**
 * @author Francois-Michel L'Heureux
 * @date 2012-03-23
 * @description: Builds a multi level menu with a fixed height and widths. 
 * Sub menus replace the current page and a back button is displayed.
 */
//TODO: test if compatible with selenium IDE
/**
 * Object memory
 */
var FmMenu = function(menuButton){
	this.menuButton = menuButton;
	this.selectedLi = null;
	this.keyFunction = FmMenu.prototype.keyFunction;
	$(menuButton).data('FmMenu', this);
};

/**
 * Main builder. Builds the menu and binds the actions
 * Requires: 
 * -options.defaultLabel: The text to display in the button when nothing is selected
 * -options.strBack: The "back" string value
 * -options.data: Objects containing data.label, data.style, data.value and data.children (an array of "data" objects)
 */
jQuery.fn.fmMenu = function(options){
	var fmMenu = new FmMenu(this);
	options = $.extend({
		displayFunction : null	//the only not required param, a function to call to generate labels 
	}, options);
	
	//build the required nodes
	this.addClass("jqMenuButton ui-widget ui-state-default ui-corner-all").html(
		'<span class="jqButtonLabel"><span class="jqDefaultLabel">' + options.defaultLabel + '</span></span><span class="ui-icon ui-icon-triangle-1-s" style="display: inline-block; vertical-align: middle;"></span>'
		+ '<div class="jqMenuContent ui-widget ui-widget-content ui-corner-all fg-menu-flyout">'
		+ '<div class="jqMenuBack ui-state-default ui-corner-all"><span class="ui-icon ui-icon-triangle-1-w" style="display: inline-block; vertical-align: middle;"></span><span>' + options.strBack + '</span></div>'
		+ '<div class="jqMenuScroll">'
		+ '</div>'
		+ '</div>'
		+ '</div>'
		+ '<input type="hidden" name="' + options.inputName + '" value=""/>');
	
	//build the menu options
	fmMenu.buildMenuRecur(options.data, 0, null, options.displayFunction);
	
	//start with the top menu
	this.find(".jqMenuScroll ul.0").show();
	
	//bind click command on menu options
	this.find(".jqMenuScroll li").click(function(event){
		var childName = "." + $(this).data('child-name');
		var tagDrilldown = null;
		if(fmMenu.menuButton.find(".jqMenuScroll").find(childName).show().length){
			//a sub menu was selected
			$(this).parents("ul:first").hide();
			fmMenu.menuButton.find(".jqMenuBack").show();
			fmMenu.menuButton.find("input").val("");
			tagDrilldown = true;
		}else{
			//a value was selected
			fmMenu.menuButton.find("input").val($(this).data('value'));
			tagDrilldown = false;
		}
		
		//update the button label
		if(!fmMenu.menuButton.find(".jqButtonLabel").data('tagDrilldown')){
			var length = fmMenu.menuButton.find(".jqButtonLabel span").length;
			if(length == 1){
				fmMenu.menuButton.find(".jqButtonLabel span").show();
			}else if(length == 2){
				fmMenu.menuButton.find(".jqButtonLabel span:last").remove();
				fmMenu.menuButton.find(".jqButtonLabel span").show();
			}else{
				fmMenu.menuButton.find(".jqButtonLabel span:last").remove();
			}
		}
		//update tagDrilldown data and add the new append the new label to the button. Hide default label. ScrollTop. 
		fmMenu.menuButton.find(".jqButtonLabel").data('tagDrilldown', tagDrilldown).append("<span> &gt; " + $(this).data('label') + "</span>");
		fmMenu.menuButton.find(".jqDefaultLabel").hide();
		fmMenu.menuButton.find(".jqMenuScroll").scrollTop(0);
		if(!tagDrilldown){
			fmMenu.closeMenu();
			event.stopPropagation();
		}
	}).hover(function(){
			fmMenu.menuButton.find("li").removeClass("ui-state-hover"); 
			fmMenu.selectedLi = $(this).addClass("ui-state-hover");},
		function(){
			$(this).removeClass("ui-state-hover");
	});//toggles hovering classes
	
	//back button action
	this.find(".jqMenuBack").click(function(){
		fmMenu.menuButton.find("." + $(".jqMenuScroll ul:visible").hide().data('grand-parent-name')).show();
		fmMenu.menuButton.find("input").val("");
		if(fmMenu.menuButton.find(".jqMenuScroll ul:visible").data('grand-parent-name') == null){
			fmMenu.menuButton.find(".jqMenuBack").hide();
		}
		fmMenu.menuButton.find(".jqButtonLabel span:last").remove();
		if(!fmMenu.menuButton.find(".jqButtonLabel").data('tagDrilldown')){
			fmMenu.menuButton.find(".jqButtonLabel span:last").remove();
			fmMenu.menuButton.find(".jqButtonLabel").data('tagDrilldown', true);
		}
		if(fmMenu.menuButton.find(".jqButtonLabel span").length == 1){
			fmMenu.menuButton.find(".jqButtonLabel span").show();
		}
		fmMenu.menuButton.find(".jqMenuScroll").scrollTop(0);
	}).hover(function(){$(this).addClass("ui-state-hover");},function(){$(this).removeClass("ui-state-hover");}
	).mousedown(function(){$(this).addClass("ui-state-active");}
	).mouseup(function(){$(this).removeClass("ui-state-active");});
	
	this.hover(function(){$(this).addClass("ui-state-hover");},function(){$(this).removeClass("ui-state-hover");})
		.click(function(event){
			$(this).addClass("ui-state-active").find(".jqMenuContent").show(); event.stopPropagation();
			$(document).focus().keydown(fmMenu, fmMenu.handleKeys);
			
	});
	$("html").click(function(){fmMenu.closeMenu();});
};

/**
 * Recursively builds the list options
 * @param menuData The data to use for the current level
 * @param parentName The parent name
 * @param grandParentName The grand parent name
 * @param displayFunction A function to call to generate the menu label (optional)
 */
FmMenu.prototype.buildMenuRecur = function(menuData, parentName, grandParentName, displayFunction){
	var options = '';
	for(i in menuData){
		var currentName = parentName + '_' + i;
		var display = displayFunction ? displayFunction(menuData[i]) : menuData[i].label; 
		options += '<li class="ui-widget ui-corner-all" data-child-name="' + currentName + '" data-value="' + menuData[i].value + '" data-label="' + menuData[i].label + '"><span class="cell" style="width: 100%;">' + display + '</span><span class="cell">' + (menuData[i].children ? '<span class="ui-icon ui-icon-triangle-1-e" style="display: inline-block; vertical-align: middle;"></span>' : '') + '</span></li>';
		if(menuData[i].children){
			this.buildMenuRecur(menuData[i].children, currentName, parentName, displayFunction);
		}
	}

	$(this.menuButton).find(".jqMenuScroll").append('<ul class="' + parentName + '" data-grand-parent-name="' + grandParentName + '">' + options + '</ul>');
};

/**
 * Called to close the menu
 */
FmMenu.prototype.closeMenu = function(){
	$(this.menuButton).removeClass("ui-state-active").find(".jqMenuContent").hide();
	if($(this.menuButton).find("input").val() == ""){
		$(this.menuButton).find("span.jqButtonLabel span:not(:first-child)").remove();
		$(this.menuButton).find("span.jqButtonLabel span").show();
		$(this.menuButton).find(".jqMenuScroll ul").hide();
		$(this.menuButton).find(".jqMenuScroll ul.0").show();
		$(this.menuButton).find(".jqMenuBack").hide();
	}
	$(document).unbind('keydown', this.handleKeys);
};

FmMenu.prototype.handleKeys = function(event){
	event.stopPropagation();
	if(event.data.keyFunction[event.keyCode]){
		return event.data.keyFunction[event.keyCode](event);
	}
};

FmMenu.prototype.keySelect = function(event){
	console.log('key select');
	console.log(this.menuButton);
};


FmMenu.prototype.keyFunction = new Array();
FmMenu.prototype.keyFunction[13] = function(event){ return this.keySelect(event); };//enter
FmMenu.prototype.keyFunction[32] = function(event){ return this.keySelect(event); };//space
FmMenu.prototype.keyFunction[39] = function(event){ return this.keySelect(event); };//right arrow
FmMenu.prototype.keyFunction[27] = function(event){ return this.keyBack(event); };//esc
FmMenu.prototype.keyFunction[37] = function(event){ return this.keyBack(event); };//left arrow
FmMenu.prototype.keyFunction[38] = function(event){
	//up
	if(event.data.selectedLi){
		//select next
		$(event.data.selectedLi).parents("ul").find('li').removeClass('ui-state-hover');
		event.data.selectedLi = $(event.data.selectedLi).prev("li");
	}
	
	if(event.data.selectedLi && event.data.selectedLi.length > 0){
		$(event.data.selectedLi).addClass('ui-state-hover');
	}else{
		event.data.menuButton.find('ul:visible').each(function(){
			$(this).find('li').removeClass('ui-state-hover');
			event.data.selectedLi = $(this).find('li:last').addClass('ui-state-hover');
		});
	}
	return false;
};
FmMenu.prototype.keyFunction[40] = function(event){
	//down
	if(event.data.selectedLi){
		//select next
		$(event.data.selectedLi).parents("ul").find('li').removeClass('ui-state-hover');
		event.data.selectedLi = $(event.data.selectedLi).next("li");
	}
	
	if(event.data.selectedLi && event.data.selectedLi.length > 0){
		$(event.data.selectedLi).addClass('ui-state-hover');
	}else{
		event.data.menuButton.find('ul:visible').each(function(){
			$(this).find('li').removeClass('ui-state-hover');
			event.data.selectedLi = $(this).find('li:first').addClass('ui-state-hover');
		});
	}
	return false;
};

